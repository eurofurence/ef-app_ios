import EurofurenceModel
import Foundation
import ScheduleComponent

class CapturingScheduleSearchViewModelDelegate: ScheduleSearchViewModelDelegate {

    private(set) var capturedSearchResults = [ScheduleEventGroupViewModel]()
    func scheduleSearchResultsUpdated(_ results: [ScheduleEventGroupViewModel]) {
        capturedSearchResults = results
    }

}
