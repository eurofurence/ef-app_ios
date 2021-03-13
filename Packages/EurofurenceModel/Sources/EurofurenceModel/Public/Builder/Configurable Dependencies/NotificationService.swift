import Foundation

public protocol NotificationService {

    func storeRemoteNotificationsToken(_ deviceToken: Data)

}
