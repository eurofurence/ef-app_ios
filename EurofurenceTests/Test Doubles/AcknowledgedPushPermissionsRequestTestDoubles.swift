//
//  AcknowledgedPushPermissionsRequestTestDoubles.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class WellBehavedAcknowledgedPushPermissions: AcknowledgedPushPermissionsRequest {

    var pushPermissionsAcknowledged: Bool = false

    func markPushPermissionsAsAcknowledged() {
        pushPermissionsAcknowledged = true
    }

}

struct UserNotAcknowledgedPushPermissions: AcknowledgedPushPermissionsRequest {

    var pushPermissionsAcknowledged: Bool {
        return false
    }

    func markPushPermissionsAsAcknowledged() { }

}

struct UserAcknowledgedPushPermissions: AcknowledgedPushPermissionsRequest {

    var pushPermissionsAcknowledged: Bool {
        return true
    }

    func markPushPermissionsAsAcknowledged() { }

}

class CapturingUserAcknowledgedPushPermissions: AcknowledgedPushPermissionsRequest {

    var pushPermissionsAcknowledged: Bool {
        return false
    }

    private(set) var didMarkUserAsAcknowledgingPushPermissionsRequest = false
    func markPushPermissionsAsAcknowledged() {
        didMarkUserAsAcknowledgingPushPermissionsRequest = true
    }
    
}
