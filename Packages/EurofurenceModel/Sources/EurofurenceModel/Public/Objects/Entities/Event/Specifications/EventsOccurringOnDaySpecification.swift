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
        let calendar = Calendar.current
        let dayComponents: Set<Calendar.Component> = [.day, .month, .year]
        let theDay = calendar.dateComponents(dayComponents, from: day.date)
        let eventDay = calendar.dateComponents(dayComponents, from: element.startDate)
        
        return theDay == eventDay
    }
    
}
