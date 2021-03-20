import EurofurenceModel
import Foundation

public protocol ScheduleComponentDelegate {

    func scheduleComponentDidSelectEvent(identifier: EventIdentifier)
    func scheduleComponentDidRequestPresentationToLeaveFeedback(for event: EventIdentifier)

}
