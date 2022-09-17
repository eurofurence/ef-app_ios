import Foundation

extension APIRequests {
    
    /// A request to register a device's Apple Push Notification Service (APNS) token against the API, to support
    /// remote push notifications from the backend to the requesting device.
    public struct RegisterPushNotificationDeviceToken: APIRequest {
        
        public typealias Output = Void
        
        /// The authentication token of the current user, for which personalised messages will be sent to the
        /// destination device. When `nil`, non-personalised messages will continue to be sent.
        public let authenticationToken: AuthenticationToken?
        
        /// The contents of the device's APNS token generated for distributing the the push notification delivery
        /// system.
        public let pushNotificationDeviceToken: Data
        
        public init(authenticationToken: AuthenticationToken?, pushNotificationDeviceToken: Data) {
            self.authenticationToken = authenticationToken
            self.pushNotificationDeviceToken = pushNotificationDeviceToken
        }
        
    }
    
}
