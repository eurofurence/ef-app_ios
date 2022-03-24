import Foundation

public struct RunningEventSpecification: Specification {
    
    public static func == (lhs: RunningEventSpecification, rhs: RunningEventSpecification) -> Bool {
        true
    }
    
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
