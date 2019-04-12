@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class CapturingScheduleModuleDelegate: ScheduleModuleDelegate {

    private(set) var capturedEventIdentifier: EventIdentifier?
    func scheduleModuleDidSelectEvent(identifier: EventIdentifier) {
        capturedEventIdentifier = identifier
    }

}
