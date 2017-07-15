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
    func registerRemoteNotificationsDeviceToken(_ token: Data) {
        capturedRemoteNotificationsDeviceToken = token
    }
    
}
