import CoreData
import Foundation

/// An object used for accessing the contents of the models events.
///
/// This class is attributed to the main actor, enabling binding of state to the user interface.
@MainActor
public class ScheduleController: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    
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
    
    private let fetchedResultsController: NSFetchedResultsController<Event>
    
    init(managedObjectContext: NSManagedObjectContext) {
        precondition(
            managedObjectContext.concurrencyType == .mainQueueConcurrencyType,
            "\(Self.self) requires a main-queue NSManagedObjectContext"
        )
        
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
        
        let daysFetchRequest = Day.temporallyOrderedFetchRequest()
        let tracksFetchRequest = Track.alphabeticallySortedFetchRequest()
        
        do {
            availableDays = try managedObjectContext.fetch(daysFetchRequest)
            selectedDay = availableDays.first
            availableTracks = try managedObjectContext.fetch(tracksFetchRequest)
            
            if let selectedDay = selectedDay {
                fetchedResultsController.fetchRequest.predicate = Event.predicate(forEventsOccurringOn: selectedDay)
            }
            
            try fetchedResultsController.performFetch()
            updateGroupings()
        } catch {
            print("")
        }
    }
    
    public nonisolated func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        Task(priority: .high) {
            await MainActor.run {
                self.updateGroupings()
            }
        }
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
