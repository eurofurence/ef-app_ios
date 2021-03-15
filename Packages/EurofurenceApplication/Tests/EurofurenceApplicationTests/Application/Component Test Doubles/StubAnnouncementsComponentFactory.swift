import EurofurenceApplication
import EurofurenceModel
import UIKit

class StubAnnouncementsComponentFactory: AnnouncementsComponentFactory {

    let stubInterface = UIViewController()
    private(set) var delegate: AnnouncementsComponentDelegate?
    func makeAnnouncementsComponent(_ delegate: AnnouncementsComponentDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }

}

extension StubAnnouncementsComponentFactory {

    func simulateDidSelectAnnouncement(_ announcement: AnnouncementIdentifier) {
        delegate?.announcementsComponentDidSelectAnnouncement(announcement)
    }

}
