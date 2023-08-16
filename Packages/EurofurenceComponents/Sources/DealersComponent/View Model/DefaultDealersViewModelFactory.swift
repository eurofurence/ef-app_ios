import EurofurenceModel
import Foundation
import UIKit

public struct DefaultDealersViewModelFactory: DealersViewModelFactory, DealersIndexDelegate {

    private let dealersService: DealersService
    private let defaultIconData: Data
    private let refreshService: RefreshService
    private let viewModel: ViewModel
    private let searchViewModel: SearchViewModel
    private let categoriesViewModel: CategoriesViewModel
    
    public init(dealersService: DealersService, refreshService: RefreshService) {
        let defaultAvatarImage = UIImage(named: "defaultAvatar", in: .module, compatibleWith: nil).unsafelyUnwrapped
        let defaultImageData = defaultAvatarImage.pngData().unsafelyUnwrapped
        
        self.init(dealersService: dealersService, defaultIconData: defaultImageData, refreshService: refreshService)
    }

    public init(
        dealersService: DealersService,
        defaultIconData: Data,
        refreshService: RefreshService
    ) {
        self.dealersService = dealersService
        self.defaultIconData = defaultIconData
        self.refreshService = refreshService

        let index = dealersService.makeDealersIndex()
        viewModel = ViewModel(refreshService: refreshService)
        searchViewModel = SearchViewModel(index: index)
        categoriesViewModel = CategoriesViewModel(categoriesCollection: index.availableCategories)

        index.setDelegate(self)
    }

    public func makeDealersViewModel(completionHandler: @escaping (DealersViewModel) -> Void) {
        completionHandler(viewModel)
    }

    public func makeDealersSearchViewModel(completionHandler: @escaping (DealersSearchViewModel) -> Void) {
        completionHandler(searchViewModel)
    }
    
    public func makeDealerCategoriesViewModel(completionHandler: @escaping (DealerCategoriesViewModel) -> Void) {
        completionHandler(categoriesViewModel)
    }

    public func alphabetisedDealersDidChange(to alphabetisedGroups: [AlphabetisedDealersGroup]) {
        let (groups, indexTitles) = makeViewModels(from: alphabetisedGroups)
        let event = AllDealersChangedEvent(
            rawGroups: alphabetisedGroups,
            alphabetisedGroups: groups,
            indexTitles: indexTitles
        )
        
        viewModel.consume(event: event)
    }

    public func indexDidProduceSearchResults(_ searchResults: [AlphabetisedDealersGroup]) {
        let (groups, indexTitles) = makeViewModels(from: searchResults)
        let event = SearchResultsDidChangeEvent(
            rawGroups: searchResults,
            alphabetisedGroups: groups,
            indexTitles: indexTitles
        )
        
        searchViewModel.consume(event: event)
    }

    private func makeViewModels(
        from alphabetisedGroups: [AlphabetisedDealersGroup]
    ) -> (groups: [DealersGroupViewModel], titles: [String]) {
        let groups = alphabetisedGroups.map { (alphabetisedGroup) -> DealersGroupViewModel in
            return DealersGroupViewModel(title: alphabetisedGroup.indexingString,
                                         dealers: alphabetisedGroup.dealers.map(makeDealerViewModel))
        }

        let indexTitles = alphabetisedGroups.map(\.indexingString)

        return (groups: groups, titles: indexTitles)
    }

    private func makeDealerViewModel(for dealer: Dealer) -> DealerVM {
        return DealerVM(dealer: dealer, defaultIconData: defaultIconData)
    }

    private class AllDealersChangedEvent {

        private(set) var rawGroups: [AlphabetisedDealersGroup]
        private(set) var alphabetisedGroups: [DealersGroupViewModel]
        private(set) var indexTitles: [String]

        init(
            rawGroups: [AlphabetisedDealersGroup],
            alphabetisedGroups: [DealersGroupViewModel],
            indexTitles: [String]
        ) {
            self.rawGroups = rawGroups
            self.alphabetisedGroups = alphabetisedGroups
            self.indexTitles = indexTitles
        }

    }

    private struct SearchResultsDidChangeEvent {

        private(set) var rawGroups: [AlphabetisedDealersGroup]
        private(set) var alphabetisedGroups: [DealersGroupViewModel]
        private(set) var indexTitles: [String]

        init(
            rawGroups: [AlphabetisedDealersGroup],
            alphabetisedGroups: [DealersGroupViewModel],
            indexTitles: [String]
        ) {
            self.rawGroups = rawGroups
            self.alphabetisedGroups = alphabetisedGroups
            self.indexTitles = indexTitles
        }

    }

    private class ViewModel: DealersViewModel, RefreshServiceObserver {

        private let refreshService: RefreshService
        private var rawGroups = [AlphabetisedDealersGroup]()
        private var groups = [DealersGroupViewModel]()
        private var indexTitles = [String]()

        init(refreshService: RefreshService) {
            self.refreshService = refreshService
            refreshService.add(self)
        }

        private var delegate: DealersViewModelDelegate?
        func setDelegate(_ delegate: DealersViewModelDelegate) {
            self.delegate = delegate
            delegate.dealerGroupsDidChange(groups, indexTitles: indexTitles)
        }

        func identifierForDealer(at indexPath: IndexPath) -> DealerIdentifier? {
            return rawGroups[indexPath.section].dealers[indexPath.item].identifier
        }

        func refresh() {
            refreshService.refreshLocalStore { (_) in }
        }

        func consume(event: AllDealersChangedEvent) {
            rawGroups = event.rawGroups
            groups = event.alphabetisedGroups
            indexTitles = event.indexTitles

            delegate?.dealerGroupsDidChange(groups, indexTitles: indexTitles)
        }

        func refreshServiceDidBeginRefreshing() {
            delegate?.dealersRefreshDidBegin()
        }

        func refreshServiceDidFinishRefreshing() {
            delegate?.dealersRefreshDidFinish()
        }

    }

    private class SearchViewModel: DealersSearchViewModel {

        private let index: DealersIndex
        private var rawGroups = [AlphabetisedDealersGroup]()
        private var groups = [DealersGroupViewModel]()
        private var indexTitles = [String]()

        init(index: DealersIndex) {
            self.index = index
        }

        private var delegate: DealersSearchViewModelDelegate?
        func setSearchResultsDelegate(_ delegate: DealersSearchViewModelDelegate) {
            self.delegate = delegate
            delegate.dealerSearchResultsDidChange(groups, indexTitles: indexTitles)
        }

        func updateSearchResults(with query: String) {
            index.performSearch(term: query)
        }

        func identifierForDealer(at indexPath: IndexPath) -> DealerIdentifier? {
            return rawGroups[indexPath.section].dealers[indexPath.item].identifier
        }

        func consume(event: SearchResultsDidChangeEvent) {
            rawGroups = event.rawGroups
            groups = event.alphabetisedGroups
            indexTitles = event.indexTitles

            delegate?.dealerSearchResultsDidChange(groups, indexTitles: indexTitles)
        }

    }

    private struct DealerVM: DealerViewModel {

        private let dealer: Dealer
        private let defaultIconData: Data

        init(dealer: Dealer, defaultIconData: Data) {
            self.dealer = dealer
            self.defaultIconData = defaultIconData

            title = dealer.preferredName
            subtitle = dealer.alternateName
            isPresentForAllDays = (dealer.isAttendingOnThursday &&
                                  dealer.isAttendingOnFriday &&
                                  dealer.isAttendingOnSaturday) || (!dealer.isAttendingOnThursday &&
                                                                   !dealer.isAttendingOnFriday &&
                                                                   !dealer.isAttendingOnSaturday)
            isAfterDarkContentPresent = dealer.isAfterDark
        }

        var title: String
        var subtitle: String?
        var isPresentForAllDays: Bool
        var isAfterDarkContentPresent: Bool

        func fetchIconPNGData(completionHandler: @escaping (Data) -> Void) {
            dealer.fetchIconPNGData { (iconPNGData) in
                completionHandler(iconPNGData ?? self.defaultIconData)
            }
        }

    }
    
    private class CategoriesViewModel: DealerCategoriesViewModel, DealerCategoriesCollectionObserver {
        
        private let categoriesCollection: DealerCategoriesCollection
        private var categoryViewModels = [CategoryViewModel]()
        
        init(categoriesCollection: DealerCategoriesCollection) {
            self.categoriesCollection = categoriesCollection
            categoriesCollection.add(self)
            
            regenerateCategoryViewModels()
        }
        
        var numberOfCategories: Int {
            return categoryViewModels.count
        }
        
        func categoryViewModel(at index: Int) -> DealerCategoryViewModel {
            return categoryViewModels[index]
        }
        
        func categoriesCollectionDidChange(_ collection: DealerCategoriesCollection) {
            regenerateCategoryViewModels()
        }
        
        private func regenerateCategoryViewModels() {
            categoryViewModels = (0..<categoriesCollection.numberOfCategories)
                .map(categoriesCollection.category(at:))
                .map(CategoryViewModel.init)
        }
        
    }
    
    private class CategoryViewModel: DealerCategoryViewModel, DealerCategoryObserver {
        
        private let category: DealerCategory
        private var currentState: CategoryViewModelState
        
        init(category: DealerCategory) {
            self.category = category
            currentState = CategoryViewModelState()
            
            category.add(self)
        }
        
        func categoryDidActivate(_ category: DealerCategory) {
            currentState = ActiveCategoryViewModelState(state: currentState)
        }
        
        func categoryDidDeactivate(_ category: DealerCategory) {
            currentState = InactiveCategoryViewModelState(state: currentState)
        }
        
        var title: String {
            return category.name
        }
        
        func add(_ observer: DealerCategoryViewModelObserver) {
            currentState.add(observer)
        }
        
        func toggleCategoryActiveState() {
            currentState.toggleCategoryState(category: category)
        }
        
    }
    
    private class CategoryViewModelState {
        
        private var observers: [DealerCategoryViewModelObserver]
        
        init() {
            observers = []
        }
        
        init(state: CategoryViewModelState) {
            observers = state.observers
            enterState()
        }
        
        final func enterState() {
            observers.forEach(provideCurrentStateContext)
        }
        
        final func add(_ observer: DealerCategoryViewModelObserver) {
            observers.append(observer)
            provideCurrentStateContext(to: observer)
        }
        
        func provideCurrentStateContext(to observer: DealerCategoryViewModelObserver) {
            
        }
        
        func toggleCategoryState(category: DealerCategory) {
            
        }
        
    }
    
    private class InactiveCategoryViewModelState: CategoryViewModelState {
        
        override func provideCurrentStateContext(to observer: DealerCategoryViewModelObserver) {
            observer.categoryDidEnterInactiveState()
        }
        
        override func toggleCategoryState(category: DealerCategory) {
            category.activate()
        }
        
    }
    
    private class ActiveCategoryViewModelState: CategoryViewModelState {
        
        override func provideCurrentStateContext(to observer: DealerCategoryViewModelObserver) {
            observer.categoryDidEnterActiveState()
        }
        
        override func toggleCategoryState(category: DealerCategory) {
            category.deactivate()
        }
        
    }

}
