import EurofurenceModel
import Foundation

class FakeEventsSearchController: EventsSearchController {

    private(set) var searchResultsDelegate: EventsSearchControllerDelegate?
    func setResultsDelegate(_ delegate: EventsSearchControllerDelegate) {
        searchResultsDelegate = delegate
    }

    private(set) var capturedSearchTerm: String?
    func changeSearchTerm(_ term: String) {
        capturedSearchTerm = term
    }

    private(set) var didRestrictSearchResultsToFavourites = false
    func restrictResultsToFavourites() {
        didRestrictSearchResultsToFavourites = true
    }

    private(set) var didLiftFavouritesSearchRestriction = false
    func removeFavouritesEventsRestriction() {
        didLiftFavouritesSearchRestriction = true
    }

}

extension FakeEventsSearchController {

    func simulateSearchResultsChanged(_ results: [Event]) {
        searchResultsDelegate?.searchResultsDidUpdate(to: results)
    }

}
