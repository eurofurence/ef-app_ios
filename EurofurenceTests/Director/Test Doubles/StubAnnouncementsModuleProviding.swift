import Eurofurence
import EurofurenceModel
import UIKit

class StubAnnouncementsModuleProviding: AnnouncementsModuleProviding {

    let stubInterface = UIViewController()
    private(set) var delegate: AnnouncementsModuleDelegate?
    func makeAnnouncementsModule(_ delegate: AnnouncementsModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }

}

extension StubAnnouncementsModuleProviding {

    func simulateDidSelectAnnouncement(_ announcement: AnnouncementIdentifier) {
        delegate?.announcementsModuleDidSelectAnnouncement(announcement)
    }

}
