@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit.UIViewController

class StubNewsModuleFactory: NewsModuleProviding {

    let stubInterface = FakeViewController()
    private(set) var delegate: NewsModuleDelegate?
    func makeNewsModule(_ delegate: NewsModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }

}

extension StubNewsModuleFactory {

    func simulatePrivateMessagesDisplayRequested() {
        delegate?.newsModuleDidRequestShowingPrivateMessages()
    }

    func simulateDidSelectAnnouncement(_ announcement: AnnouncementIdentifier) {
        delegate?.newsModuleDidSelectAnnouncement(announcement)
    }

    func simulateDidSelectEvent(_ event: Event) {
        delegate?.newsModuleDidSelectEvent(event)
    }

    func simulateAllAnnouncementsDisplayRequested() {
        delegate?.newsModuleDidRequestShowingAllAnnouncements()
    }

}
