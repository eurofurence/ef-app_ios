import Foundation

public enum NotificationContent: Equatable {
    case successfulSync
    case failedSync
    case unknown
    case announcement(AnnouncementIdentifier)
    case invalidatedAnnouncement
    case event(EventIdentifier)
    case message(MessageIdentifier)
}

public protocol NotificationService {

    func storeRemoteNotificationsToken(_ deviceToken: Data)
    func handleNotification(payload: [String: String], completionHandler: @escaping (NotificationContent) -> Void)

}
