import EurofurenceModel
import Foundation
import ScheduleComponent

class CapturingScheduleEventGroupHeader: ScheduleEventGroupHeader {

    private(set) var capturedTitle: String?
    func setEventGroupTitle(_ title: String) {
        capturedTitle = title
    }

}
