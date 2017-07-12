//
//  UserDefaultsAcknowledgedPushPermissionsRequest.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct UserDefaultsAcknowledgedPushPermissionsRequest: AcknowledgedPushPermissionsRequest {

    static let AcknowledgedPushRequestKey = "Eurofurence.UserHasAcknowledgedPushPermissionsRequest"

    var userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    var pushPermissionsAcknowledged: Bool {
        return userDefaults.bool(forKey: UserDefaultsAcknowledgedPushPermissionsRequest.AcknowledgedPushRequestKey)
    }

    func markPushPermissionsAsAcknowledged() {
        userDefaults.set(true, forKey: UserDefaultsAcknowledgedPushPermissionsRequest.AcknowledgedPushRequestKey)
    }

}
