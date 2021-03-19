import EurofurenceModel
import EventDetailComponent
import Foundation

class CapturingEventDetailViewModelDelegate: EventDetailViewModelDelegate {

    private(set) var toldEventFavourited = false
    func eventFavourited() {
        toldEventFavourited = true
    }

    private(set) var toldEventUnfavourited = false
    func eventUnfavourited() {
        toldEventUnfavourited = true
    }
    
    private(set) var leaveFeedbackInvoked = false
    func leaveFeedback() {
        leaveFeedbackInvoked = true
    }

}
