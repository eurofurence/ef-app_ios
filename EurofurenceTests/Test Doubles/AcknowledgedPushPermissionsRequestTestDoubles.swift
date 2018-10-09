//
//  WitnessedTutorialPushPermissionsRequestTestDoubles.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore

class WellBehavedAcknowledgedPushPermissions: WitnessedTutorialPushPermissionsRequest {

    var witnessedTutorialPushPermissionsRequest: Bool = false

    func markWitnessedTutorialPushPermissionsRequest() {
        witnessedTutorialPushPermissionsRequest = true
    }

}

struct UserNotAcknowledgedPushPermissions: WitnessedTutorialPushPermissionsRequest {

    var witnessedTutorialPushPermissionsRequest: Bool {
        return false
    }

    func markWitnessedTutorialPushPermissionsRequest() { }

}

struct UserAcknowledgedPushPermissions: WitnessedTutorialPushPermissionsRequest {

    var witnessedTutorialPushPermissionsRequest: Bool {
        return true
    }

    func markWitnessedTutorialPushPermissionsRequest() { }

}

class CapturingUserAcknowledgedPushPermissions: WitnessedTutorialPushPermissionsRequest {

    var witnessedTutorialPushPermissionsRequest: Bool {
        return false
    }

    private(set) var didMarkUserAsAcknowledgingPushPermissionsRequest = false
    func markWitnessedTutorialPushPermissionsRequest() {
        didMarkUserAsAcknowledgingPushPermissionsRequest = true
    }
    
}
