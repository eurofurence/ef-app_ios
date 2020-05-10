import EurofurenceModel
import UIKit.UIViewController

protocol NewsComponentFactory {

    func makeNewsComponent(_ delegate: NewsComponentDelegate) -> UIViewController

}

public protocol NewsComponentDelegate {

    func newsModuleDidRequestShowingPrivateMessages()
    func newsModuleDidSelectAnnouncement(_ announcement: AnnouncementIdentifier)
    func newsModuleDidSelectEvent(_ event: Event)
    func newsModuleDidRequestShowingAllAnnouncements()

}
