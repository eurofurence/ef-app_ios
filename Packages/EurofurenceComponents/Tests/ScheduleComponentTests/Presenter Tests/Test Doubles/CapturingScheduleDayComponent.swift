import EurofurenceModel
import Foundation
import ScheduleComponent

class CapturingScheduleDayComponent: ScheduleDayComponent {

    private(set) var capturedTitle: String?
    func setDayTitle(_ title: String) {
        capturedTitle = title
    }

}
