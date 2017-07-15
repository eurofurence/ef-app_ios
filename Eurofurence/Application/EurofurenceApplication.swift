//
//  EurofurenceApplication.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct EurofurenceApplication {

    private var remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration

    init(remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration) {
        self.remoteNotificationsTokenRegistration = remoteNotificationsTokenRegistration
    }

    func registerRemoteNotifications(deviceToken: Data) {
        remoteNotificationsTokenRegistration.registerRemoteNotificationsDeviceToken(deviceToken)
    }

}
