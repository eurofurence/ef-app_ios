import Foundation

class EventImpl: Event {

    private let characteristics: EventCharacteristics
    private unowned let eventBus: EventBus
    private let imageCache: ImagesCache
    private let shareableURLFactory: ShareableURLFactory
    
    private var tags: [String]? {
        characteristics.tags
    }
    
    private func containsTag(_ tag: String) -> Bool {
        tags?.contains(tag) ?? false
    }
    
    let identifier: EventIdentifier
    let day: ConferenceDayCharacteristics
    let room: Room
    let track: Track

    var posterGraphicPNGData: Data? {
        return characteristics.posterImageId.flatMap(imageCache.cachedImageData)
    }
    
    var bannerGraphicPNGData: Data? {
        return characteristics.bannerImageId.flatMap(imageCache.cachedImageData)
    }
    
    var title: String {
        if containsTag("essential_subtitle") {
            return characteristics.title.appending(" - ").appending(subtitle)
        } else {
            return characteristics.title
        }
    }
    
    var subtitle: String {
        characteristics.subtitle
    }
    
    var abstract: String {
        characteristics.abstract
    }
    
    var hosts: String {
        characteristics.panelHosts
    }
    
    var startDate: Date {
        characteristics.startDateTime
    }
    
    var endDate: Date {
        characteristics.endDateTime
    }
    
    var eventDescription: String {
        characteristics.eventDescription
    }
    
    var isSponsorOnly: Bool {
        containsTag("sponsors_only")
    }
    
    var isSuperSponsorOnly: Bool {
        containsTag("supersponsors_only")
    }
    
    var isArtShow: Bool {
        containsTag("art_show")
    }
    
    var isKageEvent: Bool {
        containsTag("kage")
    }
    
    var isDealersDen: Bool {
        containsTag("dealers_den")
    }
    
    var isMainStage: Bool {
        containsTag("main_stage")
    }
    
    var isPhotoshoot: Bool {
        containsTag("photoshoot")
    }
    
    var isFaceMaskRequired: Bool {
        false
    }
    
    var isAcceptingFeedback: Bool {
        characteristics.isAcceptingFeedback
    }
    
    init(
        characteristics: EventCharacteristics,
        eventBus: EventBus,
        imageCache: ImagesCache,
        shareableURLFactory: ShareableURLFactory,
        isFavourite: Bool,
        identifier: EventIdentifier,
        room: Room,
        track: Track,
        day: ConferenceDayCharacteristics
    ) {
        self.characteristics = characteristics
        self.eventBus = eventBus
        self.imageCache = imageCache
        self.shareableURLFactory = shareableURLFactory
        self.isFavourite = isFavourite

        self.identifier = identifier
        self.room = room
        self.track = track
        
        self.day = day
    }
    
    var contentURL: URL {
        return shareableURLFactory.makeURL(for: identifier)
    }

    private var observers = WeakCollection<EventObserver>()
    func add(_ observer: EventObserver) {
        observers.add(observer)
        provideFavouritedStateToObserver(observer)
    }
    
    func remove(_ observer: EventObserver) {
        observers.remove(observer)
    }

    var isFavourite: Bool {
        didSet {
            postFavouriteStateChangedEvent()
        }
    }

    func favourite() {
        isFavourite = true
        notifyObserversFavouritedStateDidChange()
    }

    func unfavourite() {
        isFavourite = false
        notifyObserversFavouritedStateDidChange()
    }
    
    func prepareFeedback() -> EventFeedback {
        if isAcceptingFeedback {
            return AcceptingEventFeedback(eventBus: eventBus, eventIdentifier: identifier)
        } else {
            return NotAcceptingEventFeedback()
        }
    }

    private func notifyObserversFavouritedStateDidChange() {
        observers.forEach(provideFavouritedStateToObserver)
    }

    private func provideFavouritedStateToObserver(_ observer: EventObserver) {
        if isFavourite {
            observer.eventDidBecomeFavourite(self)
        } else {
            observer.eventDidBecomeUnfavourite(self)
        }
    }

    private func postFavouriteStateChangedEvent() {
        let event: Any
        if isFavourite {
            event = DomainEvent.EventAddedToFavourites(identifier: identifier)
        } else {
            event = DomainEvent.EventRemovedFromFavourites(identifier: identifier)
        }

        eventBus.post(event)
    }

}

// MARK: - Filtering

extension EventImpl {
    
    func isRunning(currentTime: Date) -> Bool {
        DateInterval(start: startDate, end: endDate).contains(currentTime)
    }
    
    func isUpcoming(upcomingEventInterval: DateInterval) -> Bool {
        startDate > upcomingEventInterval.start && upcomingEventInterval.contains(startDate)
    }
    
}

// MARK: - Sorting

extension EventImpl: Comparable {
    
    static func < (lhs: EventImpl, rhs: EventImpl) -> Bool {
        lhs.title.localizedCompare(rhs.title) == .orderedAscending
    }
    
    static func == (lhs: EventImpl, rhs: EventImpl) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
}
