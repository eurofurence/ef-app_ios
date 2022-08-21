import Foundation

public protocol ScheduleScene {

    func setDelegate(_ delegate: ScheduleSceneDelegate)
    func setScheduleTitle(_ title: String)
    func showRefreshIndicator()
    func hideRefreshIndicator()
    func bind(numberOfDays: Int, using binder: ScheduleDaysBinder)
    func bind(numberOfItemsPerSection: [Int], using binder: ScheduleSceneBinder)
    func bindSearchResults(numberOfItemsPerSection: [Int], using binder: ScheduleSceneBinder)
    func selectDay(at index: Int)
    func showSearchResults()
    func hideSearchResults()
    
    func showFilterToFavouritesButton()
    func showFilterToAllEventsButton()

}

public protocol ScheduleSceneDelegate {

    func scheduleSceneDidLoad()
    func scheduleSceneDidPerformRefreshAction()
    func scheduleSceneDidSelectDay(at index: Int)
    func scheduleSceneDidSelectEvent(at indexPath: IndexPath)
    func scheduleSceneDidToggleFavouriteFilterState()
    
    func scheduleSceneDidSelectSearchResult(at indexPath: IndexPath)
    func scheduleSceneDidUpdateSearchQuery(_ query: String)
    func scheduleSceneDidChangeSearchScopeToAllEvents()
    func scheduleSceneDidChangeSearchScopeToFavouriteEvents()

}
