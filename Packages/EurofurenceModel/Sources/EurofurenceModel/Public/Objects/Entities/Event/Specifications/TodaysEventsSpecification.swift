import Foundation

public struct TodaysEventsSpecification {
    
    private let clock: any Clock
    
    public init() {
        self.init(clock: SystemClock.shared)
    }
    
    public init(clock: any Clock) {
        self.clock = clock
    }
    
}

// MARK: - TodaysEventsSpecification + Specification

extension TodaysEventsSpecification: Specification {
    
    public static func == (lhs: TodaysEventsSpecification, rhs: TodaysEventsSpecification) -> Bool {
        true
    }
    
    public typealias Element = Event
    
    public func isSatisfied(by element: Element) -> Bool {
        let earliestStartTime = earliestDateComponents(on: element.startDate)
        let latestEndTime = latestDateComponents(on: element.endDate)
        let range = DateInterval(start: earliestStartTime, end: latestEndTime)
        
        return range.contains(clock.currentDate)
    }
    
    private func earliestDateComponents(on date: Date) -> Date {
        var dateComponents = minimumDateComponentsForDateRangeChecking(from: date)
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        
        return dateComponents.date ?? date
    }
    
    private func latestDateComponents(on date: Date) -> Date {
        var dateComponents = minimumDateComponentsForDateRangeChecking(from: date)
        dateComponents.hour = 23
        dateComponents.minute = 59
        dateComponents.second = 59
        
        return dateComponents.date ?? date
    }
    
    private func minimumDateComponentsForDateRangeChecking(from date: Date) -> DateComponents {
        Calendar.current.dateComponents([.calendar, .year, .day, .month], from: date)
    }
    
}
