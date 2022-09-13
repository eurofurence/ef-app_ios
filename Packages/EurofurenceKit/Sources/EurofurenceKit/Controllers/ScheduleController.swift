import Combine
import CoreData
import Foundation
import Logging

/// An object used for accessing the contents of the models events.
///
/// This class is attributed to the main actor, enabling binding of state to the user interface.
@MainActor
public class ScheduleController: NSObject, ObservableObject {
    
    private static let logger = Logger(label: "ScheduleController")
    
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
    @Published private(set) public var matchingEventsCount: Int = 0
    
    /// The collection of groups of events, grouped by their start time.
    @Published private(set) public var eventGroups: [EventGroup] = []
    
    /// The collection of `Day` entities associated with the schedule.
    ///
    /// The collection of available days may differ from the full set of days within the model, due to the manner
    /// the schedule has been configured.
    @Published private(set) public var availableDays: [Day] = []
    
    /// The collection of `Track` entities associated with the schedule.
    ///
    /// The collection of available track may differ from the full set of tracks within the model, due to the manner
    /// the schedule has been configured.
    @Published private(set) public var availableTracks: [Track] = []
    
    /// The collection of `Room` entities associated with the schedule.
    @Published private(set) public var availableRooms: [Room] = []
    
    /// A localized description of the filter.
    @Published private(set) public var localizedFilterDescription: String?
    
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
    @Published public var selectedRoom: Room?
    
    private let scheduleConfiguration: EurofurenceModel.ScheduleConfiguration
    private let managedObjectContext: NSManagedObjectContext
    private let clock: Clock
    private let fetchedResultsController: NSFetchedResultsController<Event>
    private var subscriptions = Set<AnyCancellable>()
    private var isGroupingByDay: Bool
    
    init(
        scheduleConfiguration: EurofurenceModel.ScheduleConfiguration,
        managedObjectContext: NSManagedObjectContext,
        clock: Clock
    ) {
        precondition(
            managedObjectContext.concurrencyType == .mainQueueConcurrencyType,
            "\(Self.self) requires a main-queue NSManagedObjectContext"
        )
        
        self.scheduleConfiguration = scheduleConfiguration
        self.managedObjectContext = managedObjectContext
        self.clock = clock
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()

        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "startDate", ascending: true)
        ]
        
        isGroupingByDay = scheduleConfiguration.track != nil || scheduleConfiguration.room != nil
        let sectionNameKeyPath = isGroupingByDay ? "day" : "startDate"
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: sectionNameKeyPath,
            cacheName: nil
        )
        
        super.init()
        
        fetchedResultsController.delegate = self
        
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
        if let configuredDay = scheduleConfiguration.day {
            selectedDay = configuredDay
        } else {
            let daysFetchRequest = Day.temporallyOrderedFetchRequest()
            availableDays = try managedObjectContext.fetch(daysFetchRequest)
            selectedDay = availableDays.first
        }
    }
    
    private func fetchTracks() throws {
        if let configuredTrack = scheduleConfiguration.track {
            selectedTrack = configuredTrack
        } else {
            let tracksFetchRequest = Track.alphabeticallySortedFetchRequest()
            availableTracks = try managedObjectContext.fetch(tracksFetchRequest)
        }
    }
    
    private func fetchRooms() throws {
        if let configuredRoom = scheduleConfiguration.room {
            selectedRoom = configuredRoom
        } else {
            let roomsFetchRequest = Room.alphabeticallySortedFetchRequest()
            availableRooms = try managedObjectContext.fetch(roomsFetchRequest)
        }
    }
    
    private func updateFetchRequest() throws {
        fetchedResultsController.fetchRequest.predicate = makeFetchingPredicate()
        try fetchedResultsController.performFetch()
        updateGroupings()
    }
    
    private func makeFetchingPredicate() -> NSPredicate {
        var predicates = [NSPredicate]()
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
        
        for section in (fetchedResultsController.sections ?? []) {
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
            if let selectedTrack = selectedTrack, scheduleConfiguration.track != selectedTrack {
                return selectedTrack.name
            } else {
                return nil
            }
        }()
        
        let dayName: String? = {
            if let selectedDay = selectedDay, scheduleConfiguration.day != selectedDay {
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
        
        if let dayName {
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

// MARK: - ScheduleController + NSFetchedResultsControllerDelegate

extension ScheduleController: NSFetchedResultsControllerDelegate {
    
    public nonisolated func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        Task(priority: .high) {
            await MainActor.run {
                self.updateGroupings()
            }
        }
    }
    
}
