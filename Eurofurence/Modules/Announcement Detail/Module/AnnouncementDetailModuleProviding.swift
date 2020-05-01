import EurofurenceModel
import UIKit.UIViewController

public protocol AnnouncementDetailModuleProviding {

    func makeAnnouncementDetailModule(for announcement: AnnouncementIdentifier) -> UIViewController

}
