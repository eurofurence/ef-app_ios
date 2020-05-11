import Eurofurence
import EurofurenceModel
import Foundation

class CapturingScheduleEventGroupHeader: ScheduleEventGroupHeader {

    private(set) var capturedTitle: String?
    func setEventGroupTitle(_ title: String) {
        capturedTitle = title
    }

}
