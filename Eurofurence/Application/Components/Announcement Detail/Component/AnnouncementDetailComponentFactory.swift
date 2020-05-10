import EurofurenceModel
import UIKit.UIViewController

public protocol AnnouncementDetailComponentFactory {

    func makeAnnouncementDetailModule(
        for announcement: AnnouncementIdentifier
    ) -> UIViewController

}
