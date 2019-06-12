import Foundation

public enum ApplicationNotificationKey: String, Codable {
    case notificationContentKind
    case notificationContentIdentifier
}

public enum ApplicationNotificationContentKind: String, Codable {
    case event
}
