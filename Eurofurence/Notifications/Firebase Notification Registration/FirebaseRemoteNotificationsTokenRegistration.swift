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
        firebaseAdapter.setAPNSToken(deviceToken: token)
        firebaseAdapter.subscribe(toTopic: .cid(conventionIdentifier.identifier))
        firebaseAdapter.subscribe(toTopic: .cidiOS(conventionIdentifier.identifier))

        var fcmTopics: [FirebaseTopic] = [.ios, .version(appVersion.version)]
        switch buildConfiguration.configuration {
        case .debug:
            fcmTopics += [.debug]
            firebaseAdapter.subscribe(toTopic: .testiOS)
            firebaseAdapter.subscribe(toTopic: .testAll)

        case .release:
            firebaseAdapter.unsubscribe(fromTopic: .testiOS)
            firebaseAdapter.unsubscribe(fromTopic: .testAll)
        }

        fcmRegistration.registerFCM(firebaseAdapter.fcmToken,
                                    topics: fcmTopics,
                                    authenticationToken: userAuthenticationToken,
                                    completionHandler: completionHandler)
    }

}
