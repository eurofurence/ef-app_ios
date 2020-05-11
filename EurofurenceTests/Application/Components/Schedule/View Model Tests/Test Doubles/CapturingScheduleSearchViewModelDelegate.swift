import Eurofurence
import EurofurenceModel
import Foundation

class CapturingScheduleSearchViewModelDelegate: ScheduleSearchViewModelDelegate {

    private(set) var capturedSearchResults = [ScheduleEventGroupViewModel]()
    func scheduleSearchResultsUpdated(_ results: [ScheduleEventGroupViewModel]) {
        capturedSearchResults = results
    }

}
