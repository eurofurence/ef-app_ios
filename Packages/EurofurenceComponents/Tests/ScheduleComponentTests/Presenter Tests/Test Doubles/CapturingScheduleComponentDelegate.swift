import EurofurenceModel
import Foundation
import ScheduleComponent
import XCTEurofurenceModel

class CapturingScheduleComponentDelegate: ScheduleComponentDelegate {

    private(set) var capturedEventIdentifier: EventIdentifier?
    func scheduleComponentDidSelectEvent(identifier: EventIdentifier) {
        capturedEventIdentifier = identifier
    }
    
    private(set) var capturedEventIdentifierForFeedback: EventIdentifier?
    func scheduleComponentDidRequestPresentationToLeaveFeedback(for event: EventIdentifier) {
        capturedEventIdentifierForFeedback = event
    }

}
