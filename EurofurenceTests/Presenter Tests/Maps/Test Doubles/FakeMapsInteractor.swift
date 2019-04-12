@testable import Eurofurence
import EurofurenceModel
import Foundation

struct FakeMapsInteractor: MapsInteractor {

    var viewModel: MapsViewModel

    init(viewModel: MapsViewModel = FakeMapsViewModel()) {
        self.viewModel = viewModel
    }

    func makeMapsViewModel(completionHandler: @escaping (MapsViewModel) -> Void) {
        completionHandler(viewModel)
    }

}
