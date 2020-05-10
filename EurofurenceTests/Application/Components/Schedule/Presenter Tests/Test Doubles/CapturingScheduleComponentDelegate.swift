@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class CapturingScheduleComponentDelegate: ScheduleComponentDelegate {

    private(set) var capturedEventIdentifier: EventIdentifier?
    func scheduleComponentDidSelectEvent(identifier: EventIdentifier) {
        capturedEventIdentifier = identifier
    }

}
