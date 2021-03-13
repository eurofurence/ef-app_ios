import EurofurenceApplication
import EurofurenceModel
import Foundation

class FakeScheduleViewModelFactory: ScheduleViewModelFactory {

    private let viewModel: ScheduleViewModel
    private let searchViewModel: ScheduleSearchViewModel

    init(viewModel: CapturingScheduleViewModel = .random,
         searchViewModel: CapturingScheduleSearchViewModel = CapturingScheduleSearchViewModel()) {
        self.viewModel = viewModel
        self.searchViewModel = searchViewModel
    }

    func makeViewModel(completionHandler: @escaping (ScheduleViewModel) -> Void) {
        completionHandler(viewModel)
    }

    func makeSearchViewModel(completionHandler: @escaping (ScheduleSearchViewModel) -> Void) {
        completionHandler(searchViewModel)
    }

}
