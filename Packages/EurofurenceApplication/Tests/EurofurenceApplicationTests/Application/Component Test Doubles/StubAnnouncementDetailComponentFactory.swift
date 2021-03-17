import EurofurenceApplication
import EurofurenceModel
import UIKit.UIViewController
import XCTEurofurenceModel

class StubAnnouncementDetailComponentFactory: AnnouncementDetailComponentFactory {

    let stubInterface = UIViewController()
    private(set) var capturedModel: AnnouncementIdentifier?
    func makeAnnouncementDetailModule(for announcement: AnnouncementIdentifier) -> UIViewController {
        capturedModel = announcement
        return stubInterface
    }

}
