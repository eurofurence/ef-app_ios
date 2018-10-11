//
//  CapturingRemoteNotificationsTokenRegistration.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
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

    func failLastRequest() {
        struct SomeError: Error {}
        completionHandler?(SomeError())
    }

}
