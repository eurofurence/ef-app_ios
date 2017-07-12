//
//  UserDefaultsWitnessedSystemPushPermissionsRequest.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct UserDefaultsWitnessedSystemPushPermissionsRequest: UserWitnessedSystemPushPermissionsRequest {

    static let WitnessedSystemPushRequest = "Eurofurence.WitnessedSystemPushPermissions"

    var userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    var witnessedSystemPushPermissions: Bool {
        return userDefaults.bool(forKey: UserDefaultsWitnessedSystemPushPermissionsRequest.WitnessedSystemPushRequest)
    }

    func markUserWitnessedSystemPushPermissionsRequest() {
        userDefaults.set(true, forKey: UserDefaultsWitnessedSystemPushPermissionsRequest.WitnessedSystemPushRequest)
    }

}
