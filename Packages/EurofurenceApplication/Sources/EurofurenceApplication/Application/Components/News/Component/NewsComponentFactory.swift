import EurofurenceModel
import UIKit.UIViewController

public protocol NewsComponentFactory {

    func makeNewsComponent(_ delegate: any NewsComponentDelegate) -> UIViewController

}

public protocol NewsComponentDelegate {

    func newsModuleDidRequestShowingPrivateMessages()
    func newsModuleDidSelectAnnouncement(_ announcement: AnnouncementIdentifier)
    func newsModuleDidSelectEvent(_ event: EventIdentifier)
    func newsModuleDidRequestShowingAllAnnouncements()
    func newsModuleDidRequestShowingSettings(sender: Any)

}
