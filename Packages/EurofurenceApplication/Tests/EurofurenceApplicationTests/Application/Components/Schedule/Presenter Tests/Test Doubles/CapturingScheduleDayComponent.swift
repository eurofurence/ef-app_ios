import EurofurenceApplication
import EurofurenceModel
import Foundation

class CapturingScheduleDayComponent: ScheduleDayComponent {

    private(set) var capturedTitle: String?
    func setDayTitle(_ title: String) {
        capturedTitle = title
    }

}
