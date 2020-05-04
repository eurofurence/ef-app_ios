import EurofurenceModel
import Foundation

public protocol ScheduleModuleDelegate {

    func scheduleModuleDidSelectEvent(identifier: EventIdentifier)

}
