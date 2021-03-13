import EurofurenceModel
import Foundation

class CapturingEventsScheduleDelegate: EventsScheduleDelegate {

    private(set) var events = [Event]()
    func scheduleEventsDidChange(to events: [Event]) {
        self.events = events
    }

    private(set) var toldChangedToNilDay = false
    private(set) var capturedCurrentDay: Day?
    func currentEventDayDidChange(to day: Day?) {
        toldChangedToNilDay = day == nil
        capturedCurrentDay = day
    }

    var allDays = [Day]()
    func eventDaysDidChange(to days: [Day]) {
        self.allDays = days
    }

}
