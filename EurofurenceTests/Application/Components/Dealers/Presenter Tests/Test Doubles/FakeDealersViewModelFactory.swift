import Eurofurence
import EurofurenceModel
import Foundation

struct FakeDealersViewModelFactory: DealersViewModelFactory {

    var viewModel: DealersViewModel
    var searchViewModel: DealersSearchViewModel
    var categoriesViewModel: DealerCategoriesViewModel

    init(searchViewModel: DealersSearchViewModel) {
        self.searchViewModel = searchViewModel
        self.viewModel = CapturingDealersViewModel()
        self.categoriesViewModel = FakeDealerCategoriesViewModel()
    }

    init(dealerViewModel: DealerViewModel) {
        let group = DealersGroupViewModel(title: .random, dealers: [dealerViewModel])
        self.init(dealerGroupViewModels: [group])
    }

    init(dealerGroupViewModels: [DealersGroupViewModel]) {
        let viewModel = CapturingDealersViewModel(dealerGroups: dealerGroupViewModels)
        self.init(viewModel: viewModel)
    }

    init(viewModel: DealersViewModel,
         searchViewModel: DealersSearchViewModel = CapturingDealersSearchViewModel(),
         categoriesViewModel: DealerCategoriesViewModel = FakeDealerCategoriesViewModel()) {
        self.viewModel = viewModel
        self.searchViewModel = searchViewModel
        self.categoriesViewModel = categoriesViewModel
    }

    func makeDealersViewModel(completionHandler: @escaping (DealersViewModel) -> Void) {
        completionHandler(viewModel)
    }

    func makeDealersSearchViewModel(completionHandler: @escaping (DealersSearchViewModel) -> Void) {
        completionHandler(searchViewModel)
    }
    
    func makeDealerCategoriesViewModel(completionHandler: @escaping (DealerCategoriesViewModel) -> Void) {
        completionHandler(categoriesViewModel)
    }

}
