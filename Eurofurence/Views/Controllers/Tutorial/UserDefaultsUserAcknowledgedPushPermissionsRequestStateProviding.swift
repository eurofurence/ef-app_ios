//
//  UserDefaultsUserAcknowledgedPushPermissionsRequestStateProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct UserDefaultsUserAcknowledgedPushPermissionsRequestStateProviding: UserAcknowledgedPushPermissionsRequestStateProviding {

    static let AcknowledgedPushRequestKey = "Eurofurence.UserHasAcknowledgedPushPermissionsRequest"

    var userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    var userHasAcknowledgedRequestForPushPermissions: Bool {
        return userDefaults.bool(forKey: UserDefaultsUserAcknowledgedPushPermissionsRequestStateProviding.AcknowledgedPushRequestKey)
    }

    func markUserAsAcknowledgingPushPermissionsRequest() {
        userDefaults.set(true, forKey: UserDefaultsUserAcknowledgedPushPermissionsRequestStateProviding.AcknowledgedPushRequestKey)
    }

}
