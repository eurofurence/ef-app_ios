import EurofurenceApplication
import EurofurenceModel
import UIKit.UIViewController

class CapturingAnnouncementDetailScene: UIViewController, AnnouncementDetailScene {

    private(set) var delegate: AnnouncementDetailSceneDelegate?
    func setDelegate(_ delegate: AnnouncementDetailSceneDelegate) {
        self.delegate = delegate
    }

    private(set) var capturedTitle: String?
    func setAnnouncementTitle(_ title: String) {
        capturedTitle = title
    }

    private(set) var capturedAnnouncementHeading: String?
    func setAnnouncementHeading(_ heading: String) {
        capturedAnnouncementHeading = heading
    }

    private(set) var capturedAnnouncementContents: NSAttributedString?
    func setAnnouncementContents(_ contents: NSAttributedString) {
        capturedAnnouncementContents = contents
    }

    private(set) var capturedAnnouncementImagePNGData: Data?
    func setAnnouncementImagePNGData(_ pngData: Data) {
        capturedAnnouncementImagePNGData = pngData
    }

}
