import Foundation

protocol AnnouncementsScene {

    func setDelegate(_ delegate: AnnouncementsSceneDelegate)
    func setAnnouncementsTitle(_ title: String)
    func bind(numberOfAnnouncements: Int, using binder: AnnouncementsBinder)
    func deselectAnnouncement(at index: Int)

}

protocol AnnouncementsSceneDelegate {

    func announcementsSceneDidLoad()
    func announcementsSceneDidSelectAnnouncement(at index: Int)

}
