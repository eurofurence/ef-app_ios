import Foundation

class DealersPresenter: DealersSceneDelegate, DealersViewModelDelegate, DealersSearchViewModelDelegate {

    private struct AllDealersBinder: DealersBinder {

        var binder: DealerGroupsBinder

        func bind(_ component: DealerGroupHeader, toDealerGroupAt index: Int) {
            binder.bind(component, toDealerGroupAt: index)
        }

        func bind(_ component: DealerComponent, toDealerAt indexPath: IndexPath) {
            binder.bind(component, toDealerAt: indexPath)
        }

    }

    private struct SearchResultsBindingAdapter: DealersSearchResultsBinder {

        var binder: DealerGroupsBinder

        func bind(_ component: DealerGroupHeader, toDealerSearchResultGroupAt index: Int) {
            binder.bind(component, toDealerGroupAt: index)
        }

        func bind(_ component: DealerComponent, toDealerSearchResultAt indexPath: IndexPath) {
            binder.bind(component, toDealerAt: indexPath)
        }

    }

    private struct DealerGroupsBinder {

        var viewModels: [DealersGroupViewModel]

        func bind(_ component: DealerGroupHeader, toDealerGroupAt index: Int) {
            let group = viewModels[index]
            component.setDealersGroupTitle(group.title)
        }

        func bind(_ component: DealerComponent, toDealerAt indexPath: IndexPath) {
            let group = viewModels[indexPath.section]
            let dealer = group.dealers[indexPath.item]

            component.setDealerTitle(dealer.title)
            component.setDealerSubtitle(dealer.subtitle)
            dealer.fetchIconPNGData(completionHandler: component.setDealerIconPNGData)

            if dealer.isPresentForAllDays {
                component.hideNotPresentOnAllDaysWarning()
            } else {
                component.showNotPresentOnAllDaysWarning()
            }

            if dealer.isAfterDarkContentPresent {
                component.showAfterDarkContentWarning()
            } else {
                component.hideAfterDarkContentWarning()
            }
        }

    }
    
    private struct CategoriesBinder: DealerCategoriesBinder {
        
        var viewModel: DealerCategoriesViewModel
        
        func bindCategoryComponent(_ component: DealerCategoryComponentScene, at index: Int) {
            let categoryViewModel = viewModel.categoryViewModel(at: index)
            categoryViewModel.add(CategoryBinder(viewModel: categoryViewModel, component: component))
        }
        
    }
    
    private struct CategoryBinder: DealerCategoryViewModelObserver {
        
        private let viewModel: DealerCategoryViewModel
        private let component: DealerCategoryComponentScene
        
        init(viewModel: DealerCategoryViewModel, component: DealerCategoryComponentScene) {
            self.viewModel = viewModel
            self.component = component
            
            component.setCategoryTitle(viewModel.title)
            component.setSelectionHandler(viewModel.toggleCategoryActiveState)
            viewModel.add(self)
        }
        
        func categoryDidEnterActiveState() {
            component.showActiveCategoryIndicator()
        }
        
        func categoryDidEnterInactiveState() {
            component.hideActiveCategoryIndicator()
        }
        
    }

    private let scene: DealersScene
    private let interactor: DealersViewModelFactory
    private let delegate: DealersComponentDelegate
    private var viewModel: DealersViewModel?
    private var searchViewModel: DealersSearchViewModel?

    init(scene: DealersScene, interactor: DealersViewModelFactory, delegate: DealersComponentDelegate) {
        self.scene = scene
        self.interactor = interactor
        self.delegate = delegate

        scene.setDelegate(self)
        scene.setDealersTitle(.dealers)
    }

    func dealersSceneDidLoad() {
        interactor.makeDealersViewModel { (viewModel) in
            self.viewModel = viewModel
            viewModel.setDelegate(self)
        }

        interactor.makeDealersSearchViewModel { (viewModel) in
            self.searchViewModel = viewModel
            viewModel.setSearchResultsDelegate(self)
        }
    }

    func dealersSceneDidChangeSearchQuery(to query: String) {
        searchViewModel?.updateSearchResults(with: query)
    }

    func dealersSceneDidSelectDealer(at indexPath: IndexPath) {
        scene.deselectDealer(at: indexPath)

        guard let identifier = viewModel?.identifierForDealer(at: indexPath) else { return }
        delegate.dealersModuleDidSelectDealer(identifier: identifier)
    }

    func dealersSceneDidSelectDealerSearchResult(at indexPath: IndexPath) {
        guard let identifier = searchViewModel?.identifierForDealer(at: indexPath) else { return }
        delegate.dealersModuleDidSelectDealer(identifier: identifier)
    }

    func dealersSceneDidPerformRefreshAction() {
        viewModel?.refresh()
    }
    
    func dealersSceneDidRevealCategoryFiltersScene(_ filtersScene: DealerCategoriesFilterScene) {
        interactor.makeDealerCategoriesViewModel { (viewModel) in
            filtersScene.bind(viewModel.numberOfCategories, using: CategoriesBinder(viewModel: viewModel))
        }
    }

    func dealersRefreshDidBegin() {
        scene.showRefreshIndicator()
    }

    func dealersRefreshDidFinish() {
        scene.hideRefreshIndicator()
    }

    func dealerGroupsDidChange(_ groups: [DealersGroupViewModel], indexTitles: [String]) {
        let itemsPerSection = groups.map(\.dealers.count)
        let binder = DealerGroupsBinder(viewModels: groups)
        scene.bind(numberOfDealersPerSection: itemsPerSection,
                   sectionIndexTitles: indexTitles,
                   using: AllDealersBinder(binder: binder))
    }

    func dealerSearchResultsDidChange(_ groups: [DealersGroupViewModel], indexTitles: [String]) {
        let itemsPerSection = groups.map(\.dealers.count)
        let binder = DealerGroupsBinder(viewModels: groups)
        scene.bindSearchResults(numberOfDealersPerSection: itemsPerSection,
                                sectionIndexTitles: indexTitles,
                                using: SearchResultsBindingAdapter(binder: binder))
    }

}
