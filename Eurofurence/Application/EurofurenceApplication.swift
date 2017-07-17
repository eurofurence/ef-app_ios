//
//  EurofurenceApplication.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class EurofurenceApplication: LoginStateObserver {

    private var remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration
    private var registeredDeviceToken: Data?

    init(remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration,
         loginController: LoginController) {
        self.remoteNotificationsTokenRegistration = remoteNotificationsTokenRegistration
        loginController.add(self)
    }

    func registerRemoteNotifications(deviceToken: Data) {
        registeredDeviceToken = deviceToken
        remoteNotificationsTokenRegistration.registerRemoteNotificationsDeviceToken(deviceToken, userAuthenticationToken: nil)
    }

    func userDidLogin(authenticationToken: String) {
        guard let registeredDeviceToken = registeredDeviceToken else { return }
        remoteNotificationsTokenRegistration.registerRemoteNotificationsDeviceToken(registeredDeviceToken, userAuthenticationToken: authenticationToken)
    }

}
