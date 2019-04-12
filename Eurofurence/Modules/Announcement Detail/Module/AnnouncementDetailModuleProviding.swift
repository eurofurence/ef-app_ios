import EurofurenceModel
import UIKit.UIViewController

protocol AnnouncementDetailModuleProviding {

    func makeAnnouncementDetailModule(for announcement: AnnouncementIdentifier) -> UIViewController

}
