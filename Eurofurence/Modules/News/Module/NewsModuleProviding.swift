import EurofurenceModel
import UIKit.UIViewController

protocol NewsModuleProviding {

    func makeNewsModule(_ delegate: NewsModuleDelegate) -> UIViewController

}

protocol NewsModuleDelegate {

    func newsModuleDidRequestShowingPrivateMessages()
    func newsModuleDidSelectAnnouncement(_ announcement: AnnouncementIdentifier)
    func newsModuleDidSelectEvent(_ event: Event)
    func newsModuleDidRequestShowingAllAnnouncements()

}
