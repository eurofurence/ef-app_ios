import Foundation

public struct EventsOccurringOnDaySpecification {
    
    private let day: Day
    
    public init(day: Day) {
        self.day = day
    }
    
}

// MARK: - EventsOccurringOnDaySpecification + Specification

extension EventsOccurringOnDaySpecification: Specification {
    
    public typealias Element = Event
    
    public func isSatisfied(by element: Element) -> Bool {
        day.identifier == element.day.identifier
    }
    
}
