import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class CapturingScheduleSearchViewModel: ScheduleSearchViewModel {

    fileprivate var delegate: ScheduleSearchViewModelDelegate?
    func setDelegate(_ delegate: ScheduleSearchViewModelDelegate) {
        self.delegate = delegate
    }

    private(set) var capturedSearchInput: String?
    func updateSearchResults(input: String) {
        capturedSearchInput = input
    }

    fileprivate var stubbedIdentifiersByIndexPath = [IndexPath: EventIdentifier]()
    func identifierForEvent(at indexPath: IndexPath) -> EventIdentifier? {
        return stubbedIdentifiersByIndexPath[indexPath]
    }

    private(set) var didFilterToFavourites = false
    func filterToFavourites() {
        didFilterToFavourites = true
    }

    private(set) var didFilterToAllEvents = false
    func filterToAllEvents() {
        didFilterToAllEvents = true
    }

    private(set) var indexPathForFavouritedEvent: IndexPath?
    func favouriteEvent(at indexPath: IndexPath) {
        indexPathForFavouritedEvent = indexPath
    }

    private(set) var indexPathForUnfavouritedEvent: IndexPath?
    func unfavouriteEvent(at indexPath: IndexPath) {
        indexPathForUnfavouritedEvent = indexPath
    }

}

extension CapturingScheduleSearchViewModel {

    func simulateSearchResultsUpdated(_ results: [ScheduleEventGroupViewModel]) {
        delegate?.scheduleSearchResultsUpdated(results)
    }

    func stub(_ identifier: EventIdentifier, at indexPath: IndexPath) {
        stubbedIdentifiersByIndexPath[indexPath] = identifier
    }

}
