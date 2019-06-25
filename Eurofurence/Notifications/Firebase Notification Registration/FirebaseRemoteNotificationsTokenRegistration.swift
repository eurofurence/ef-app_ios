import EurofurenceModel
import Foundation

public struct FirebaseRemoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration {

    private var buildConfiguration: BuildConfigurationProviding
    private var appVersion: AppVersionProviding
    private var firebaseAdapter: FirebaseAdapter
    private var conventionIdentifier: ConventionIdentifier
    private var fcmRegistration: FCMDeviceRegistration

    public init(buildConfiguration: BuildConfigurationProviding,
                appVersion: AppVersionProviding,
                conventionIdentifier: ConventionIdentifier,
                firebaseAdapter: FirebaseAdapter,
                fcmRegistration: FCMDeviceRegistration) {
        self.buildConfiguration = buildConfiguration
        self.appVersion = appVersion
        self.conventionIdentifier = conventionIdentifier
        self.firebaseAdapter = firebaseAdapter
        self.fcmRegistration = fcmRegistration
    }

    public func registerRemoteNotificationsDeviceToken(_ token: Data?,
                                                       userAuthenticationToken: String?,
                                                       completionHandler: @escaping (Error?) -> Void) {
        let conventionIdentifierString = conventionIdentifier.identifier
        
        firebaseAdapter.setAPNSToken(deviceToken: token)
        firebaseAdapter.subscribe(toTopic: .cid(conventionIdentifierString))
        firebaseAdapter.subscribe(toTopic: .cidiOS(conventionIdentifierString))

        var fcmTopics: [FirebaseTopic] = [.ios, .version(appVersion.version), .backendCID(conventionIdentifierString)]
        if buildConfiguration.configuration == .debug {
            fcmTopics += [.debug]
        }

        fcmRegistration.registerFCM(firebaseAdapter.fcmToken,
                                    topics: fcmTopics,
                                    authenticationToken: userAuthenticationToken,
                                    completionHandler: completionHandler)
    }

}
