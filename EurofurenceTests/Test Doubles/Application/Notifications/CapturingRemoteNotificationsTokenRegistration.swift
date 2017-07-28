//
//  CapturingRemoteNotificationsTokenRegistration.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingRemoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration {

    private(set) var capturedRemoteNotificationsDeviceToken: Data?
    private(set) var capturedUserAuthenticationToken: String?
    private(set) var numberOfRegistrations = 0
    private var completionHandler: ((Error?) -> Void)?
    func registerRemoteNotificationsDeviceToken(_ token: Data?,
                                                userAuthenticationToken: String?,
                                                completionHandler: @escaping (Error?) -> Void) {
        capturedRemoteNotificationsDeviceToken = token
        capturedUserAuthenticationToken = userAuthenticationToken
        numberOfRegistrations += 1
        self.completionHandler = completionHandler
    }
    
    func succeedLastRequest() {
        completionHandler?(nil)
    }
    
    func failLastRequest() {
        struct SomeError: Error {}
        completionHandler?(SomeError())
    }
    
}
