import Combine
import CoreData
import Foundation

extension EurofurenceModel {
    
    /// Designates the configuration to apply when assembling a `Schedule`.
    public struct ScheduleConfiguration {
        
        let day: Day?
        let track: Track?
        let room: Room?
        let favouritesOnly: Bool
        
        public init(
            day: Day? = nil,
            track: Track? = nil,
            room: Room? = nil,
            favouritesOnly: Bool = false
        ) {
            self.day = day
            self.track = track
            self.room = room
            self.favouritesOnly = favouritesOnly
        }
        
    }
    
    /// Produces a `Schedule` for processing the events within the model.
    /// - Parameter scheduleConfiguration: A configuration object designating any custom parameters to apply.
    /// - Returns: An initialized `Schedule` with the configuration applied.
    public func makeSchedule(
        configuration: ScheduleConfiguration = ScheduleConfiguration()
    ) -> Schedule {
        Schedule(
            configuration: configuration,
            managedObjectContext: viewContext,
            clock: self.configuration.clock
        )
    }
    
}
