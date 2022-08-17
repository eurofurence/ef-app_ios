import Foundation

class ConcreteScheduleRepository: ClockDelegate, ScheduleRepository {

    // MARK: Nested Types

    private struct FavouriteEventHandler: EventConsumer {

        private unowned let service: ConcreteScheduleRepository

        init(service: ConcreteScheduleRepository) {
            self.service = service
        }

        func consume(event: DomainEvent.EventAddedToFavourites) {
            let identifier = event.identifier
            service.favouriteEvent(identifier: identifier)
        }

    }

    private struct UnfavouriteEventHandler: EventConsumer {

        private unowned let service: ConcreteScheduleRepository

        init(service: ConcreteScheduleRepository) {
            self.service = service
        }

        func consume(event: DomainEvent.EventRemovedFromFavourites) {
            let identifier = event.identifier
            service.unfavouriteEvent(identifier: identifier)
        }

    }
    
    private func unfavouriteEvent(identifier: EventIdentifier) {
        dataStore.performTransaction { (transaction) in
            transaction.deleteFavouriteEventIdentifier(identifier)
        }

        favouriteEventIdentifiers.removeAll(where: { $0 == identifier })
        provideFavouritesInformationToObservers()
    }

    // MARK: Properties

    private var observers = WeakCollection<ScheduleRepositoryObserver>()
    private var subscriptions = Set<AnyHashable>()
    private let dataStore: DataStore
    private let imageCache: ImagesCache
    private let clock: Clock
    private let timeIntervalForUpcomingEventsSinceNow: TimeInterval
    private let eventBus: EventBus
    private let shareableURLFactory: ShareableURLFactory

    private(set) var events = [EventCharacteristics]()
    private(set) var rooms = [RoomCharacteristics]()
    private(set) var tracks = [TrackCharacteristics]()
    private(set) var days = [ConferenceDayCharacteristics]()

    private var runningEvents: [EventImpl] = []
    private var upcomingEvents: [EventImpl] = []

    private(set) var eventModels = [EventImpl]() {
        didSet {
            refreshEventProperties()
        }
    }

    private(set) var dayModels = [Day]()

    private(set) var favouriteEventIdentifiers = [EventIdentifier]()

    // MARK: Initialization
    
    init(
        eventBus: EventBus,
        dataStore: DataStore,
        imageCache: ImagesCache,
        clock: Clock,
        timeIntervalForUpcomingEventsSinceNow: TimeInterval,
        shareableURLFactory: ShareableURLFactory
    ) {
        self.dataStore = dataStore
        self.imageCache = imageCache
        self.clock = clock
        self.timeIntervalForUpcomingEventsSinceNow = timeIntervalForUpcomingEventsSinceNow
        self.eventBus = eventBus
        self.shareableURLFactory = shareableURLFactory

        subscriptions.insert(eventBus.subscribe(consumer: DataStoreChangedConsumer { [weak self] in
            self?.reconstituteEventsFromDataStore()
        }))
        
        subscriptions.insert(eventBus.subscribe(consumer: FavouriteEventHandler(service: self)))
        subscriptions.insert(eventBus.subscribe(consumer: UnfavouriteEventHandler(service: self)))

        reconstituteFavouritesFromDataStore()
        reconstituteEventsFromDataStore()
        sortFavourites()
        
        clock.setDelegate(self)
    }
    
    private func sortFavourites() {
        favouriteEventIdentifiers = eventModels
            .filter({ favouriteEventIdentifiers.contains($0.identifier) })
            .sorted()
            .map(\.identifier)
    }

    func clockDidTick(to time: Date) {
        refreshUpcomingEvents()
        updateObserversWithLatestScheduleInformation()
    }

    func eventsSatisfying(predicate: (Event) -> Bool) -> [Event] {
        return eventModels.filter(predicate)
    }

    // MARK: Functions

    func loadSchedule(tag: String) -> Schedule {
        return EventsScheduleAdapter(tag: tag, schedule: self, clock: clock, eventBus: eventBus)
    }

    func add(_ observer: ScheduleRepositoryObserver) {
        observers.add(observer)
        provideScheduleInformation(to: observer)
    }

    // MARK: Private

    private func refreshEventProperties() {
        refreshRunningEvents()
        refreshUpcomingEvents()

        updateObserversWithLatestScheduleInformation()
    }

    private func refreshRunningEvents() {
        let now = clock.currentDate
        runningEvents = eventModels.filter({ (event) -> Bool in
            event.isRunning(currentTime: now)
        }).sorted()
    }

    private func refreshUpcomingEvents() {
        let now = clock.currentDate
        let range = DateInterval(start: now, end: now.addingTimeInterval(timeIntervalForUpcomingEventsSinceNow))
        upcomingEvents = eventModels.filter({ (event) -> Bool in
            event.isUpcoming(upcomingEventInterval: range)
        }).sorted()
    }

    private func updateObserversWithLatestScheduleInformation() {
        observers.forEach(provideScheduleInformation)
    }

    private func provideScheduleInformation(to observer: ScheduleRepositoryObserver) {
        observer.runningEventsDidChange(to: runningEvents)
        observer.upcomingEventsDidChange(to: upcomingEvents)
        observer.eventsDidChange(to: eventModels)
        observer.favouriteEventsDidChange(favouriteEventIdentifiers)
    }

    private func provideFavouritesInformationToObservers() {
        observers.forEach { (observer) in
            observer.favouriteEventsDidChange(favouriteEventIdentifiers)
        }
    }

    private func reconstituteEventsFromDataStore() {
        let events = dataStore.fetchEvents()
        let rooms = dataStore.fetchRooms()
        let tracks = dataStore.fetchTracks()
        let conferenceDays = dataStore.fetchConferenceDays()

        if let events = events, let rooms = rooms, let tracks = tracks, let conferenceDays = conferenceDays {
            self.days = conferenceDays.reduce(.empty, { (result, next) in
                if result.contains(where: { $0.identifier == next.identifier }) { return result }
                return result + [next]
            })

            self.events = events
            self.rooms = rooms
            self.tracks = tracks

            eventModels = events.sorted(by: { $0.startDateTime < $1.startDateTime }).compactMap(makeEventModel)

            dayModels = makeDays(from: days)
            eventBus.post(DomainEvent.EventsChanged())
        }
    }

    func makeEventModel(from event: EventCharacteristics) -> EventImpl? {
        guard let room = rooms.first(where: { $0.identifier == event.roomIdentifier }) else { return nil }
        guard let track = tracks.first(where: { $0.identifier == event.trackIdentifier }) else { return nil }
        guard let day = days.first(where: { $0.identifier == event.dayIdentifier }) else { return nil }

        let eventIdentifier = EventIdentifier(event.identifier)

        return EventImpl(
            characteristics: event,
            eventBus: eventBus,
            imageCache: imageCache,
            shareableURLFactory: shareableURLFactory,
            isFavourite: favouriteEventIdentifiers.contains(eventIdentifier),
            identifier: eventIdentifier,
            room: Room(name: room.name),
            track: Track(name: track.name),
            day: day
        )
    }
    
    private func reconstituteFavouritesFromDataStore() {
        favouriteEventIdentifiers = dataStore.fetchFavouriteEventIdentifiers().defaultingTo(.empty)
    }
    
    private func makeDays(from models: [ConferenceDayCharacteristics]) -> [Day] {
        return models.map(makeDay).sorted()
    }

    private func makeDay(from model: ConferenceDayCharacteristics) -> Day {
        return Day(date: model.date, identifier: model.identifier)
    }

    private func favouriteEvent(identifier: EventIdentifier) {
        dataStore.performTransaction { (transaction) in
            transaction.saveFavouriteEventIdentifier(identifier)
        }
        
        favouriteEventIdentifiers.append(identifier)
        sortFavourites()
        provideFavouritesInformationToObservers()
    }

}
