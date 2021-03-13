import EurofurenceModel
import Foundation

public protocol AnnouncementsComponentDelegate {

    func announcementsComponentDidSelectAnnouncement(
        _ announcement: AnnouncementIdentifier
    )

}
