import EurofurenceApplication
import EurofurenceModel
import Foundation
import XCTEurofurenceModel

struct DummyEventDetailViewModelFactory: EventDetailViewModelFactory {

    func makeViewModel(for event: EventIdentifier, completionHandler: @escaping (EventDetailViewModel) -> Void) {

    }

}
