import Foundation

public struct RunningEventSpecification: Specification {
    
    private let clock: Clock
    
    public init(clock: Clock) {
        self.clock = clock
    }
    
    public func isSatisfied(by element: Event) -> Bool {
        let runningRange = DateInterval(start: element.startDate, end: element.endDate)
        let now = clock.currentDate
        
        return runningRange.contains(now)
    }
    
}
