import EurofurenceApplication
import EurofurenceModel
import Foundation

struct FakeMapsViewModelFactory: MapsViewModelFactory {

    var viewModel: MapsViewModel

    init(viewModel: MapsViewModel = FakeMapsViewModel()) {
        self.viewModel = viewModel
    }

    func makeMapsViewModel(completionHandler: @escaping (MapsViewModel) -> Void) {
        completionHandler(viewModel)
    }

}
