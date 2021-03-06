import Eurofurence
import EurofurenceModel
import Foundation

class CapturingAnnouncementComponent: AnnouncementItemComponent {

    private(set) var capturedTitle: String?
    func setAnnouncementTitle(_ title: String) {
        capturedTitle = title
    }

    private(set) var capturedDetail: NSAttributedString?
    func setAnnouncementDetail(_ detail: NSAttributedString) {
        capturedDetail = detail
    }

    private(set) var capturedReceivedDateTime: String?
    func setAnnouncementReceivedDateTime(_ receivedDateTime: String) {
        capturedReceivedDateTime = receivedDateTime
    }

    private(set) var didHideUnreadIndicator = false
    func hideUnreadIndicator() {
        didHideUnreadIndicator = true
    }

    private(set) var didShowUnreadIndicator = false
    func showUnreadIndicator() {
        didShowUnreadIndicator = true
    }

}
