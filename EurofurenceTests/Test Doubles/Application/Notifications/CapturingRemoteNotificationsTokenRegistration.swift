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
    private(set) var numberOfRegistrations = 0
    func registerRemoteNotificationsDeviceToken(_ token: Data) {
        capturedRemoteNotificationsDeviceToken = token
        numberOfRegistrations += 1
    }
    
}
