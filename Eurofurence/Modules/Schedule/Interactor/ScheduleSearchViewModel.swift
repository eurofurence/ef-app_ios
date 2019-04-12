import EurofurenceModel
import Foundation

protocol ScheduleSearchViewModel {

    func setDelegate(_ delegate: ScheduleSearchViewModelDelegate)
    func updateSearchResults(input: String)
    func identifierForEvent(at indexPath: IndexPath) -> EventIdentifier?
    func filterToFavourites()
    func filterToAllEvents()
    func favouriteEvent(at indexPath: IndexPath)
    func unfavouriteEvent(at indexPath: IndexPath)

}

protocol ScheduleSearchViewModelDelegate {

    func scheduleSearchResultsUpdated(_ results: [ScheduleEventGroupViewModel])

}
