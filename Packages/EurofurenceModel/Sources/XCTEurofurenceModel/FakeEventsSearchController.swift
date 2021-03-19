import EurofurenceModel
import Foundation

public class FakeEventsSearchController: EventsSearchController {
    
    public init() {
        
    }

    public private(set) var searchResultsDelegate: EventsSearchControllerDelegate?
    public func setResultsDelegate(_ delegate: EventsSearchControllerDelegate) {
        searchResultsDelegate = delegate
    }

    public private(set) var capturedSearchTerm: String?
    public func changeSearchTerm(_ term: String) {
        capturedSearchTerm = term
    }

    public private(set) var didRestrictSearchResultsToFavourites = false
    public func restrictResultsToFavourites() {
        didRestrictSearchResultsToFavourites = true
    }

    public private(set) var didLiftFavouritesSearchRestriction = false
    public func removeFavouritesEventsRestriction() {
        didLiftFavouritesSearchRestriction = true
    }

}

extension FakeEventsSearchController {

    public func simulateSearchResultsChanged(_ results: [Event]) {
        searchResultsDelegate?.searchResultsDidUpdate(to: results)
    }

}
