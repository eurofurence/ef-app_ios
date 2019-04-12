import Foundation

protocol AnnouncementComponent {

    func setAnnouncementTitle(_ title: String)
    func setAnnouncementDetail(_ detail: NSAttributedString)
    func setAnnouncementReceivedDateTime(_ receivedDateTime: String)
    func hideUnreadIndicator()
    func showUnreadIndicator()

}
