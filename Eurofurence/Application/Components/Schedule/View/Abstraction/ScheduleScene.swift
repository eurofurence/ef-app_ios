import Foundation

protocol ScheduleScene {

    func setDelegate(_ delegate: ScheduleSceneDelegate)
    func setScheduleTitle(_ title: String)
    func showRefreshIndicator()
    func hideRefreshIndicator()
    func bind(numberOfDays: Int, using binder: ScheduleDaysBinder)
    func bind(numberOfItemsPerSection: [Int], using binder: ScheduleSceneBinder)
    func bindSearchResults(numberOfItemsPerSection: [Int], using binder: ScheduleSceneBinder)
    func selectDay(at index: Int)
    func deselectEvent(at indexPath: IndexPath)
    func deselectSearchResult(at indexPath: IndexPath)
    func showSearchResults()
    func hideSearchResults()

}

protocol ScheduleSceneDelegate {

    func scheduleSceneDidLoad()
    func scheduleSceneDidPerformRefreshAction()
    func scheduleSceneDidSelectDay(at index: Int)
    func scheduleSceneDidSelectEvent(at indexPath: IndexPath)
    func scheduleSceneDidSelectSearchResult(at indexPath: IndexPath)

    func scheduleSceneDidUpdateSearchQuery(_ query: String)
    func scheduleSceneDidChangeSearchScopeToAllEvents()
    func scheduleSceneDidChangeSearchScopeToFavouriteEvents()

}
