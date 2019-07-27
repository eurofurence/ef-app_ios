import Foundation

public protocol EventsSearchController {

    func setResultsDelegate(_ delegate: EventsSearchControllerDelegate)
    func changeSearchTerm(_ term: String)
    func restrictResultsToFavourites()
    func removeFavouritesEventsRestriction()

}

public protocol EventsSearchControllerDelegate {

    func searchResultsDidUpdate(to results: [Event])

}
