import CoreData
import Combine
import Foundation

extension EurofurenceModel {
    
    /// Designates the configuration to apply when assembling a `ScheduleController`.
    public struct ScheduleConfiguration {
        
        let day: Day?
        let track: Track?
        
        public init(day: Day? = nil, track: Track? = nil) {
            self.day = day
            self.track = track
        }
        
    }
    
    /// Produces a `ScheduleController` for processing the events within the model.
    /// - Parameter scheduleConfiguration: A configuration object designating any custom parameters to apply.
    /// - Returns: An initialized `ScheduleController` with the configuration applied.
    public func makeScheduleController(
        scheduleConfiguration: ScheduleConfiguration = ScheduleConfiguration()
    ) -> ScheduleController {
        ScheduleController(
            scheduleConfiguration: scheduleConfiguration,
            managedObjectContext: viewContext,
            clock: configuration.clock
        )
    }
    
}
