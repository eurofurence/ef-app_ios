import Foundation

/// A request to log out from the Eurofurence application service.
public struct LogoutRequest: Hashable {
    
    /// The previously acquired `AuthenticationToken` of the user that is signed in.
    public var authenticationToken: AuthenticationToken
    
    /// The device's Apple Push Notification Service (APNS) token for delivering push messages to the presently
    /// authenticated user.
    ///
    /// Upon successful logout, user-specific pushes to this specific token will no longer occur.
    public var pushNotificationDeviceToken: Data?
    
    public init(authenticationToken: AuthenticationToken, pushNotificationDeviceToken: Data?) {
        self.authenticationToken = authenticationToken
        self.pushNotificationDeviceToken = pushNotificationDeviceToken
    }
    
}
