import Foundation

extension APIRequests {
    
    /// A request to register a device's Apple Push Notification Service (APNS) token against the API, to support
    /// remote push notifications from the backend to the requesting device.
    public class RegisterPushNotificationDeviceToken: APIRequest {
        
        public func hash(into hasher: inout Hasher) {
            if let authenticationToken = authenticationToken {
                hasher.combine(authenticationToken)
            }
            
            if let pushNotificationDeviceToken = pushNotificationDeviceToken {
                hasher.combine(pushNotificationDeviceToken)
            }
        }
        
        public static func == (
            lhs: RegisterPushNotificationDeviceToken,
            rhs: RegisterPushNotificationDeviceToken
        ) -> Bool {
            lhs.authenticationToken == rhs.authenticationToken &&
            lhs.pushNotificationDeviceToken == rhs.pushNotificationDeviceToken
        }
        
        public typealias Output = Void
        
        /// The authentication token of the current user, for which personalised messages will be sent to the
        /// destination device. When `nil`, non-personalised messages will continue to be sent.
        public let authenticationToken: AuthenticationToken?
        
        /// The contents of the device's APNS token generated for distributing the the push notification delivery
        /// system.
        public let pushNotificationDeviceToken: Data?
        
        public init(authenticationToken: AuthenticationToken?, pushNotificationDeviceToken: Data?) {
            self.authenticationToken = authenticationToken
            self.pushNotificationDeviceToken = pushNotificationDeviceToken
        }
        
        public func execute(with context: APIRequestExecutionContext) async throws -> Void {
            let conventionIdentifier = context.conventionIdentifier
            let hostVersion = context.hostVersion
            
            let pushNotificationServiceRegistration = PushNotificationServiceRegistration(
                pushNotificationDeviceTokenData: pushNotificationDeviceToken,
                channels: ["\(conventionIdentifier)", "\(conventionIdentifier)-ios"]
            )
            
            context.pushNotificationService.registerForPushNotifications(
                registration: pushNotificationServiceRegistration
            )
            
            let registerDeviceTokenRequest = RegisterDeviceTokenRequest(
                DeviceId: context.pushNotificationService.pushNotificationServiceToken,
                Topics: ["iOS", "version-\(hostVersion)", "cid-\(conventionIdentifier)"]
            )
            
            let encoder = JSONEncoder()
            let body = try encoder.encode(registerDeviceTokenRequest)
            
            let registrationURL = context.makeURL(subpath: "PushNotifications/FcmDeviceRegistration")
            
            var headers = NetworkRequest.Headers()
            if let authenticationToken = authenticationToken {
                headers["Authorization"] = "Bearer \(authenticationToken.stringValue)"
            }
            
            let networkRequest = NetworkRequest(url: registrationURL, body: body, method: .post, headers: headers)
            try await context.network.perform(request: networkRequest)
        }
        
        private struct RegisterDeviceTokenRequest: Encodable {
            var DeviceId: String
            var Topics: [String]
        }
        
    }
    
}
