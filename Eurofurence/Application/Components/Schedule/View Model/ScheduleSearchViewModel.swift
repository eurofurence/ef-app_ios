import EurofurenceModel
import Foundation

public protocol ScheduleSearchViewModel {

    func setDelegate(_ delegate: ScheduleSearchViewModelDelegate)
    func updateSearchResults(input: String)
    func identifierForEvent(at indexPath: IndexPath) -> EventIdentifier?
    func filterToFavourites()
    func filterToAllEvents()

}

public protocol ScheduleSearchViewModelDelegate {

    func scheduleSearchResultsUpdated(_ results: [ScheduleEventGroupViewModel])

}
