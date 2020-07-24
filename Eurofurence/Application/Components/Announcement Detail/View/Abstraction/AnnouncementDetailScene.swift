import Foundation.NSAttributedString

public protocol AnnouncementDetailScene: AnyObject {

    func setDelegate(_ delegate: AnnouncementDetailSceneDelegate)
    func setAnnouncementTitle(_ title: String)
    func setAnnouncementHeading(_ heading: String)
    func setAnnouncementContents(_ contents: NSAttributedString)
    func setAnnouncementImagePNGData(_ pngData: Data)

}

public protocol AnnouncementDetailSceneDelegate {

    func announcementDetailSceneDidLoad()

}
