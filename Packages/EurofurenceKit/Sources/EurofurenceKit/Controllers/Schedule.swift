import Combine
import CoreData
import Foundation
import Logging

/// An object used for accessing the contents of the models events.
///
/// This class is attributed to the main actor, enabling binding of state to the user interface.
@MainActor
public class Schedule: NSObject, ObservableObject {
    
    private static let logger = Logger(label: "Schedule")
    
    /// The attribute used to group a collection of `Events` within a schedule.
    public enum Group: Hashable, Identifiable {
        
        public var id: some Hashable {
            switch self {
            case .startDate(let date):
                return AnyHashable(date)
                
            case .day(let day):
                return AnyHashable(day)
            }
        }
        
        /// A grouping of events under a common starting time.
        case startDate(Date)
        
        /// A grouping of events under a common `Day`.
        case day(Day)
        
    }
    
    /// A typealias for the collection of groups associated with a schedule.
    public typealias EventGroup = Grouping<Group, Event>
    
    /// The number of `Event`s in this schedule that matches the designated criteria.
    @Published public private(set) var matchingEventsCount: Int = 0
    
    /// The collection of groups of events, grouped by their start time.
    @Published public private(set) var eventGroups: [EventGroup] = []
    
    /// The collection of `Day` entities associated with the schedule.
    ///
    /// The collection of available days may differ from the full set of days within the model, due to the manner
    /// the schedule has been configured.
    @Published public private(set) var availableDays: [Day] = []
    
    /// The collection of `Track` entities associated with the schedule.
    ///
    /// The collection of available track may differ from the full set of tracks within the model, due to the manner
    /// the schedule has been configured.
    @Published public private(set) var availableTracks: [Track] = []
    
    /// The collection of `Room` entities associated with the schedule.
    @Published public private(set) var availableRooms: [Room] = []
    
    /// A localized description of the filter.
    @Published public private(set) var localizedFilterDescription: String?
    
    /// A flag to designate whether the schedule should only contain events the user has favourited.
    @Published public var favouritesOnly: Bool = false {
        didSet {
            refetchEvents()
        }
    }
    
    /// A textual query to apply for filtering against this schedule.
    @Published public var query: String = "" {
        didSet {
            refetchEvents()
        }
    }
    
    /// The currently active `Day` within the schedule, used to filter the collection of events.
    @Published public var selectedDay: Day? {
        didSet {
            refetchEvents()
        }
    }
    
    /// The currently active `Track` within the schedule, used to filter the collection of events.
    @Published public var selectedTrack: Track? {
        didSet {
            refetchEvents()
        }
    }
    
    /// The currently active `Room` within the schedule, used to filter the collection of events.
    @Published public var selectedRoom: Room? {
        didSet {
            refetchEvents()
        }
    }
    
    private let configuration: EurofurenceModel.ScheduleConfiguration
    private let managedObjectContext: NSManagedObjectContext
    private let clock: Clock
    private var fetchedResultsController: NSFetchedResultsController<Event>?
    private var subscriptions = Set<AnyCancellable>()
    
    private var isGroupingByDay: Bool {
        selectedDay == nil
    }
    
    init(
        configuration: EurofurenceModel.ScheduleConfiguration,
        managedObjectContext: NSManagedObjectContext,
        clock: Clock
    ) {
        precondition(
            managedObjectContext.concurrencyType == .mainQueueConcurrencyType,
            "\(Self.self) requires a main-queue NSManagedObjectContext"
        )
        
        self.configuration = configuration
        self.managedObjectContext = managedObjectContext
        self.clock = clock
        self.favouritesOnly = configuration.favouritesOnly
        
        super.init()
        
        do {
            try fetchQueryableEntities()
            attachClockSubscriber()
            try updateFetchRequest()
        } catch {
            Self.logger.error(
                "Failed to prepare schedule for querying.",
                metadata: ["Error": .string(String(describing: error))]
            )
        }
    }
    
    private func attachClockSubscriber() {
        clock
            .significantTimeChangePublisher
            .sink { [weak self] date in
                self?.updateCurrentDay(currentTime: date)
            }
            .store(in: &subscriptions)
    }
    
    private func updateCurrentDay(currentTime: Date) {
        let currentTimeComponents = Calendar.current.dateComponents([.day], from: currentTime)
        for day in availableDays {
            let dayComponents = Calendar.current.dateComponents([.day], from: day.date)
            if dayComponents == currentTimeComponents {
                selectedDay = day
            }
        }
    }
    
    private func fetchQueryableEntities() throws {
        try fetchDays()
        try fetchTracks()
        try fetchRooms()
    }
    
    private func fetchDays() throws {
        if let configuredDay = configuration.day {
            selectedDay = configuredDay
        } else {
            let daysFetchRequest = Day.temporallyOrderedFetchRequest()
            availableDays = try managedObjectContext.fetch(daysFetchRequest)
        }
    }
    
    private func fetchTracks() throws {
        if let configuredTrack = configuration.track {
            selectedTrack = configuredTrack
        } else {
            let tracksFetchRequest = Track.alphabeticallySortedFetchRequest()
            availableTracks = try managedObjectContext.fetch(tracksFetchRequest)
        }
    }
    
    private func fetchRooms() throws {
        if let configuredRoom = configuration.room {
            selectedRoom = configuredRoom
        } else {
            let roomsFetchRequest = Room.alphabeticallySortedFetchRequest()
            availableRooms = try managedObjectContext.fetch(roomsFetchRequest)
        }
    }
    
    private func updateFetchRequest() throws {
        updateFetchedResultsSectioningKeyPathIfNeeded()
        
        fetchedResultsController?.fetchRequest.predicate = makeFetchingPredicate()
        try fetchedResultsController?.performFetch()
        updateGroupings()
    }
    
    private func updateFetchedResultsSectioningKeyPathIfNeeded() {
        let sectionNameKeyPath = isGroupingByDay ? "day.date" : "startDate"
        if fetchedResultsController?.sectionNameKeyPath != sectionNameKeyPath {
            let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: sectionNameKeyPath, ascending: true),
                NSSortDescriptor(key: "startDate", ascending: true),
                NSSortDescriptor(key: "title", ascending: true)
            ]
            
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: managedObjectContext,
                sectionNameKeyPath: sectionNameKeyPath,
                cacheName: nil
            )
            
            fetchedResultsController?.delegate = self
        }
    }
    
    private func makeFetchingPredicate() -> NSPredicate {
        var predicates = [NSPredicate]()
        
        if favouritesOnly {
            predicates.append(NSPredicate(format: "isFavourite == YES"))
        }
        
        if query.isEmpty == false {
            predicates.append(Event.predicateForTextualSearch(query: query))
        }
        
        if let selectedDay = selectedDay {
            predicates.append(Event.predicate(forEventsOccurringOn: selectedDay))
        }
        
        if let selectedTrack = selectedTrack {
            predicates.append(Event.predicate(forEventsInTrack: selectedTrack))
        }
        
        if let selectedRoom = selectedRoom {
            predicates.append(Event.predicate(forEventsInRoom: selectedRoom))
        }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    
    private func updateGroupings() {
        var newGroups = [EventGroup]()
        var matchingEventsCount = 0
        
        for section in (fetchedResultsController?.sections ?? []) {
            guard let events = (section.objects as? [Event]) else { continue }
            guard events.isEmpty == false else { continue }
            
            let group: EventGroup
            if isGroupingByDay {
                let grouping = events[0].day
                group = EventGroup(id: .day(grouping), elements: events)
            } else {
                let grouping = events[0].startDate
                group = EventGroup(id: .startDate(grouping), elements: events)
            }
            
            newGroups.append(group)
            matchingEventsCount += events.count
        }
        
        self.matchingEventsCount = matchingEventsCount
        self.eventGroups = newGroups
    }
    
    private func refetchEvents() {
        do {
            try updateFetchRequest()
            updateLocalizedFilter()
        } catch {
            Self.logger.error(
                "Failed to re-fetch schedule events following a change to the critera",
                metadata: ["Error": .string(String(describing: error))]
            )
        }
    }
    
    private func updateLocalizedFilter() {
        let trackName: String? = {
            if let selectedTrack = selectedTrack, configuration.track != selectedTrack {
                return selectedTrack.name
            } else {
                return nil
            }
        }()
        
        let dayName: String? = {
            if let selectedDay = selectedDay, configuration.day != selectedDay {
                return selectedDay.name
            } else {
                return nil
            }
        }()
        
        let roomName: String? = selectedRoom?.shortName
        
        var description = ""
        if let trackName = trackName {
            description.append(trackName)
        }
        
        if let roomName = roomName {
            if description.isEmpty {
                description.append(roomName)
            } else {
                description.append(" in ")
                description.append(roomName)
            }
        }
        
        if let dayName = dayName {
            if description.isEmpty {
                description.append(dayName)
            } else {
                description.append(" on ")
                description.append(dayName)
            }
        }
        
        if description.isEmpty {
            localizedFilterDescription = nil
        } else {
            localizedFilterDescription = description
        }
    }
    
}

// MARK: - Schedule + NSFetchedResultsControllerDelegate

extension Schedule: NSFetchedResultsControllerDelegate {
    
    public nonisolated func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        Task(priority: .high) {
            await MainActor.run {
                self.updateGroupings()
            }
        }
    }
    
}
