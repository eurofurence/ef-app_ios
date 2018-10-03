//
//  FirebaseRemoteNotificationsTokenRegistration.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

public struct FirebaseRemoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration {

    private var buildConfiguration: BuildConfigurationProviding
    private var appVersion: AppVersionProviding
    private var firebaseAdapter: FirebaseAdapter
    private var fcmRegistration: FCMDeviceRegistration

    public init(buildConfiguration: BuildConfigurationProviding,
         appVersion: AppVersionProviding,
         firebaseAdapter: FirebaseAdapter,
         fcmRegistration: FCMDeviceRegistration) {
        self.buildConfiguration = buildConfiguration
        self.appVersion = appVersion
        self.firebaseAdapter = firebaseAdapter
        self.fcmRegistration = fcmRegistration
    }

    public func registerRemoteNotificationsDeviceToken(_ token: Data?,
                                                userAuthenticationToken: String?,
                                                completionHandler: @escaping (Error?) -> Void) {
        firebaseAdapter.setAPNSToken(deviceToken: token)
        firebaseAdapter.subscribe(toTopic: .liveiOS)
        firebaseAdapter.subscribe(toTopic: .liveAll)

        var fcmTopics: [FirebaseTopic] = [.live, .ios, .version(appVersion.version)]
        switch buildConfiguration.configuration {
        case .debug:
            fcmTopics += [.debug, .test]
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
