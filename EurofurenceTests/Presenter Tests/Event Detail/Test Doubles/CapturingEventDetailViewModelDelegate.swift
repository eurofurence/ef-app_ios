@testable import Eurofurence
import EurofurenceModel
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

}
