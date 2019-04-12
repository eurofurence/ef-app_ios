import EurofurenceModel
import Foundation

class CapturingEventsSearchControllerDelegate: EventsSearchControllerDelegate {

    private(set) var toldSearchResultsUpdatedToEmptyArray = false
    private(set) var capturedSearchResults = [Event]()
    func searchResultsDidUpdate(to results: [Event]) {
        toldSearchResultsUpdatedToEmptyArray = results.isEmpty
        capturedSearchResults = results
    }

}
