@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

struct DummyEventDetailInteractor: EventDetailInteractor {

    func makeViewModel(for event: EventIdentifier, completionHandler: @escaping (EventDetailViewModel) -> Void) {

    }

}
