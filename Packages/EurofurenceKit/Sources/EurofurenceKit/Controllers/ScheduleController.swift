import CoreData
import Foundation
import Logging

/// An object used for accessing the contents of the models events.
///
/// This class is attributed to the main actor, enabling binding of state to the user interface.
@MainActor
public class ScheduleController: NSObject, ObservableObject {
    
    private static let logger = Logger(label: "ScheduleController")
    
    
    /// A typealias for the collection of groups associated with a schedule.
    public typealias EventGroup = Grouping<Date, Event>
    
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
    
    /// The currently active `Day` within the schedule, used to filter the collection of events.
    @Published public var selectedDay: Day?
    
    /// The currently active `Track` within the schedule, used to filter the collection of events.
    @Published public var selectedTrack: Track?
    
    private let scheduleConfiguration: EurofurenceModel.ScheduleConfiguration
    private let managedObjectContext: NSManagedObjectContext
    private let fetchedResultsController: NSFetchedResultsController<Event>
    
    init(
        scheduleConfiguration: EurofurenceModel.ScheduleConfiguration,
        managedObjectContext: NSManagedObjectContext
    ) {
        precondition(
            managedObjectContext.concurrencyType == .mainQueueConcurrencyType,
            "\(Self.self) requires a main-queue NSManagedObjectContext"
        )
        
        self.scheduleConfiguration = scheduleConfiguration
        self.managedObjectContext = managedObjectContext
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()

        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "startDate", ascending: true)
        ]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: "startDate",
            cacheName: nil
        )
        
        super.init()
        
        fetchedResultsController.delegate = self
        
        do {
            try prepareFetchedResultsControllerUsingConfiguration()
            try fetchedResultsController.performFetch()
            updateGroupings()
        } catch {
            Self.logger.error(
                "Failed to prepare schedule for querying.",
                metadata: ["Error": .string(String(describing: error))]
            )
        }
    }
    
    private func prepareFetchedResultsControllerUsingConfiguration() throws {
        try fetchQueryableEntities()
        updateFetchRequest()
    }
    
    private func fetchQueryableEntities() throws {
        try fetchDays()
        try fetchTracks()
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
        let tracksFetchRequest = Track.alphabeticallySortedFetchRequest()
        availableTracks = try managedObjectContext.fetch(tracksFetchRequest)
    }
    
    private func updateFetchRequest() {
        var predicates = [NSPredicate]()
        if let selectedDay = selectedDay {
            predicates.append(Event.predicate(forEventsOccurringOn: selectedDay))
        }
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchedResultsController.fetchRequest.predicate = predicate
    }
    
    private func updateGroupings() {
        var newGroups = [EventGroup]()
        
        for section in (fetchedResultsController.sections ?? []) {
            guard let events = (section.objects as? [Event]) else { continue }
            guard events.isEmpty == false else { continue }
            
            let grouping = events[0].startDate
            let group = EventGroup(id: grouping, elements: events)
            newGroups.append(group)
        }
        
        self.eventGroups = newGroups
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
