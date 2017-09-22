//
//  UserDefaultsWitnessedSystemPushPermissionsRequest.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct UserDefaultsWitnessedSystemPushPermissionsRequest: PushPermissionsStateProviding {

    static let WitnessedSystemPushRequest = "Eurofurence.WitnessedSystemPushPermissions"

    var userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    var requestedPushNotificationAuthorization: Bool {
        return userDefaults.bool(forKey: UserDefaultsWitnessedSystemPushPermissionsRequest.WitnessedSystemPushRequest)
    }

    func attemptedPushAuthorizationRequest() {
        userDefaults.set(true, forKey: UserDefaultsWitnessedSystemPushPermissionsRequest.WitnessedSystemPushRequest)
    }

}
