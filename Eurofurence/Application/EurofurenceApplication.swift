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
    private var clock: Clock
    private var userAuthenticationTokenValid = false
    private var registeredDeviceToken: Data?
    private var userAuthenticationToken: String?

    init(remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration,
         loginController: LoginController,
         clock: Clock) {
        self.remoteNotificationsTokenRegistration = remoteNotificationsTokenRegistration
        self.clock = clock
        loginController.add(self)
    }

    func registerRemoteNotifications(deviceToken: Data) {
        registeredDeviceToken = deviceToken
        var token: String? = nil
        if userAuthenticationTokenValid {
            token = userAuthenticationToken
        }

        remoteNotificationsTokenRegistration.registerRemoteNotificationsDeviceToken(deviceToken,
                                                                                    userAuthenticationToken: token)
    }

    func userDidLogin(authenticationToken: String, expires: Date) {
        userAuthenticationToken = authenticationToken
        userAuthenticationTokenValid = clock.currentDate.timeIntervalSince1970 < expires.timeIntervalSince1970

        guard let registeredDeviceToken = registeredDeviceToken else { return }

        remoteNotificationsTokenRegistration.registerRemoteNotificationsDeviceToken(registeredDeviceToken,
                                                                                    userAuthenticationToken: authenticationToken)
    }

}
