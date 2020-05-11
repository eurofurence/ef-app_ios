import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

struct DummyEventDetailViewModelFactory: EventDetailViewModelFactory {

    func makeViewModel(for event: EventIdentifier, completionHandler: @escaping (EventDetailViewModel) -> Void) {

    }

}
