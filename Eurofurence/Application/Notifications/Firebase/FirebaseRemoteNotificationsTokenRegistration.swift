//
//  FirebaseRemoteNotificationsTokenRegistration.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct FirebaseRemoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration {

    private var buildConfiguration: BuildConfigurationProviding
    private var appVersion: AppVersionProviding
    private var firebaseAdapter: FirebaseAdapter
    private var fcmRegistration: FCMDeviceRegistration

    init(buildConfiguration: BuildConfigurationProviding,
         appVersion: AppVersionProviding,
         firebaseAdapter: FirebaseAdapter,
         fcmRegistration: FCMDeviceRegistration) {
        self.buildConfiguration = buildConfiguration
        self.appVersion = appVersion
        self.firebaseAdapter = firebaseAdapter
        self.fcmRegistration = fcmRegistration
    }

    func registerRemoteNotificationsDeviceToken(_ token: Data, userAuthenticationToken: String?) {
        firebaseAdapter.setAPNSToken(deviceToken: token)

        var fcmTopics: [FirebaseTopic] = [.ios, .version(appVersion.version)]
        switch buildConfiguration.configuration {
        case .debug:
            fcmTopics += [.debug, .test, .live]
            firebaseAdapter.subscribe(toTopic: .testAll)
            firebaseAdapter.unsubscribe(fromTopic: .liveAll)

        case .release:
            fcmTopics += [.live]
            firebaseAdapter.subscribe(toTopic: .liveAll)
            firebaseAdapter.unsubscribe(fromTopic: .testAll)
        }

        fcmRegistration.registerFCM(firebaseAdapter.fcmToken,
                                    topics: fcmTopics,
                                    authenticationToken: userAuthenticationToken)
    }

}
