import CoreData
import Combine
import Foundation

extension EurofurenceModel {
    
    /// Designates the configuration to apply when assembling a `ScheduleController`.
    public struct ScheduleConfiguration {
        
        let day: Day?
        
        public init(day: Day? = nil) {
            self.day = day
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
            managedObjectContext: viewContext
        )
    }
    
}
