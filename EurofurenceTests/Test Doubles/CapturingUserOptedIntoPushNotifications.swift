//
//  CapturingWitnessedSystemPushPermissionsRequest.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingWitnessedSystemPushPermissionsRequest: WitnessedSystemPushPermissionsRequest {

    var witnessedSystemPushPermissionsRequest: Bool = false

    private(set) var didPermitRegisteringForPushNotifications = false
    func markWitnessedSystemPushPermissionsRequest() {
        didPermitRegisteringForPushNotifications = true
    }
    
}
