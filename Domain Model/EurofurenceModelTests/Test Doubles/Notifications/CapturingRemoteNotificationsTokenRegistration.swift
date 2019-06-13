import EurofurenceModel
import Foundation

class CapturingRemoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration {

    private(set) var capturedRemoteNotificationsDeviceToken: Data?
    private(set) var capturedUserAuthenticationToken: String?
    private(set) var numberOfRegistrations = 0
    private var completionHandler: ((Error?) -> Void)?
    private(set) var didRegisterNilPushTokenAndAuthToken = false
    func registerRemoteNotificationsDeviceToken(_ token: Data?,
                                                userAuthenticationToken: String?,
                                                completionHandler: @escaping (Error?) -> Void) {
        capturedRemoteNotificationsDeviceToken = token
        capturedUserAuthenticationToken = userAuthenticationToken
        numberOfRegistrations += 1
        self.completionHandler = completionHandler

        didRegisterNilPushTokenAndAuthToken = token == nil && userAuthenticationToken == nil
    }

    func succeedLastRequest() {
        completionHandler?(nil)
    }

    struct SomeError: Error {}
    func failLastRequest() {
        completionHandler?(SomeError())
    }

}
