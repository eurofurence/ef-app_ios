//
//  CapturingUserWitnessedSystemPushPermissionsRequest.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingUserWitnessedSystemPushPermissionsRequest: UserWitnessedSystemPushPermissionsRequest {

    var witnessedSystemPushPermissions: Bool = false

    private(set) var didPermitRegisteringForPushNotifications = false
    func markUserWitnessedSystemPushPermissionsRequest() {
        didPermitRegisteringForPushNotifications = true
    }
    
}
