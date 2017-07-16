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
    private var firebaseAdapter: FirebaseAdapter
    private var fcmRegistration: FCMDeviceRegistration

    init(buildConfiguration: BuildConfigurationProviding,
         firebaseAdapter: FirebaseAdapter,
         fcmRegistration: FCMDeviceRegistration) {
        self.buildConfiguration = buildConfiguration
        self.firebaseAdapter = firebaseAdapter
        self.fcmRegistration = fcmRegistration
    }

    func registerRemoteNotificationsDeviceToken(_ token: Data) {
        firebaseAdapter.setAPNSToken(deviceToken: token)
        firebaseAdapter.subscribe(toTopic: .announcements)

        var fcmTopics: [FirebaseTopic] = [.ios, .announcements]
        switch buildConfiguration.configuration {
        case .debug:
            fcmTopics += [.debug, .test]
            firebaseAdapter.subscribe(toTopic: .test)
            firebaseAdapter.unsubscribe(fromTopic: .live)

        case .release:
            fcmTopics += [.live]
            firebaseAdapter.subscribe(toTopic: .live)
            firebaseAdapter.unsubscribe(fromTopic: .test)
        }

        fcmRegistration.registerFCM(firebaseAdapter.fcmToken, topics: fcmTopics)
    }

}
