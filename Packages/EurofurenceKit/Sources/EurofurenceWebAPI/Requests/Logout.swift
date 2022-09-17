import Foundation

extension APIRequests {
    
    /// A request to log out from the Eurofurence application service.
    public class Logout: RegisterPushNotificationDeviceToken {
        
        public init(pushNotificationDeviceToken: Data?) {
            super.init(authenticationToken: nil, pushNotificationDeviceToken: pushNotificationDeviceToken)
        }
        
    }
    
}
