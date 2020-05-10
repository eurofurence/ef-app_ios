@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

struct FakeEventDetailViewModelFactory: EventDetailViewModelFactory {

    private let viewModel: EventDetailViewModel
    private let event: Event

    init(viewModel: EventDetailViewModel, for event: Event) {
        self.viewModel = viewModel
        self.event = event
    }

    func makeViewModel(for event: EventIdentifier, completionHandler: @escaping (EventDetailViewModel) -> Void) {
        if event == self.event.identifier {
            completionHandler(viewModel)
        }
    }

}
