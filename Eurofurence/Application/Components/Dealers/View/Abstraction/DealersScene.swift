import Foundation

public protocol DealersScene {

    func setDelegate(_ delegate: DealersSceneDelegate)
    func setDealersTitle(_ title: String)
    func showRefreshIndicator()
    func hideRefreshIndicator()
    func bind(numberOfDealersPerSection: [Int], sectionIndexTitles: [String], using binder: DealersBinder)
    func bindSearchResults(numberOfDealersPerSection: [Int], sectionIndexTitles: [String], using binder: DealersSearchResultsBinder)

}

public protocol DealersSceneDelegate {

    func dealersSceneDidLoad()
    func dealersSceneDidChangeSearchQuery(to query: String)
    func dealersSceneDidSelectDealer(at indexPath: IndexPath)
    func dealersSceneDidSelectDealerSearchResult(at indexPath: IndexPath)
    func dealersSceneDidPerformRefreshAction()
    func dealersSceneDidRevealCategoryFiltersScene(_ filtersScene: DealerCategoriesFilterScene)

}

public protocol DealerCategoriesFilterScene {
    
    func bind(_ numberOfCategories: Int, using binder: DealerCategoriesBinder)
    
}

public protocol DealerCategoriesBinder {
    
    func bindCategoryComponent(_ component: DealerCategoryComponentScene, at index: Int)
    
}

public protocol DealerCategoryComponentScene {
    
    func setCategoryTitle(_ title: String)
    func setSelectionHandler(_ handler: @escaping () -> Void)
    func showActiveCategoryIndicator()
    func hideActiveCategoryIndicator()
    
}
