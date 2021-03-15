import Foundation

public protocol RemoteNotificationsTokenRegistration {
    
    func registerRemoteNotificationsDeviceToken(
        _ token: Data?,
        userAuthenticationToken: String?,
        completionHandler: @escaping (Error?) -> Void
    )
    
}
