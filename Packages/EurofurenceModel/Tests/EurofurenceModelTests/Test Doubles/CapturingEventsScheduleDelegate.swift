import EurofurenceModel
import Foundation

class CapturingScheduleDelegate: ScheduleDelegate {

    private(set) var events = [Event]()
    func scheduleEventsDidChange(to events: [Event]) {
        self.events = events
    }

    var toldChangedToNilDay = false
    private(set) var capturedCurrentDay: Day?
    func currentEventDayDidChange(to day: Day?) {
        toldChangedToNilDay = day == nil
        capturedCurrentDay = day
    }

    var allDays = [Day]()
    func eventDaysDidChange(to days: [Day]) {
        self.allDays = days
    }
    
    private(set) var latestScheduleSpecification: AnySpecification<Event>?
    func scheduleSpecificationChanged(to newSpecification: AnySpecification<Event>) {
        latestScheduleSpecification = newSpecification
    }

}
