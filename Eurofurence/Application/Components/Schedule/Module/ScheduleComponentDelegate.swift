import EurofurenceModel
import Foundation

public protocol ScheduleComponentDelegate {

    func scheduleComponentDidSelectEvent(identifier: EventIdentifier)

}
