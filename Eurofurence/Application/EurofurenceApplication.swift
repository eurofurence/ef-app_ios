//
//  EurofurenceApplication.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct EurofurenceApplication: LoginStateObserver {

    private var remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration

    init(remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration,
         loginController: LoginController) {
        self.remoteNotificationsTokenRegistration = remoteNotificationsTokenRegistration
        loginController.add(self)
    }

    func registerRemoteNotifications(deviceToken: Data) {
        remoteNotificationsTokenRegistration.registerRemoteNotificationsDeviceToken(deviceToken)
    }

    func userDidLogin() {
        remoteNotificationsTokenRegistration.registerRemoteNotificationsDeviceToken(Data())
    }

}
