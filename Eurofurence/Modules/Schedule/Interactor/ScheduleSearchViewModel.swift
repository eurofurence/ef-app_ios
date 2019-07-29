import EurofurenceModel
import Foundation

protocol ScheduleSearchViewModel {

    func setDelegate(_ delegate: ScheduleSearchViewModelDelegate)
    func updateSearchResults(input: String)
    func identifierForEvent(at indexPath: IndexPath) -> EventIdentifier?
    func filterToFavourites()
    func filterToAllEvents()

}

protocol ScheduleSearchViewModelDelegate {

    func scheduleSearchResultsUpdated(_ results: [ScheduleEventGroupViewModel])

}
