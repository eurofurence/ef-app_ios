//
//  UserDefaultsWitnessedTutorialPushPermissionsRequest.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct UserDefaultsWitnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest {

    static let WitnessedTutorialPushPermissionsRequestKey = "Eurofurence.WitnessedTutorialPushPermissionsRequest"

    var userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    var witnessedTutorialPushPermissionsRequest: Bool {
        return userDefaults.bool(forKey: UserDefaultsWitnessedTutorialPushPermissionsRequest.WitnessedTutorialPushPermissionsRequestKey)
    }

    func markWitnessedTutorialPushPermissionsRequest() {
		let remoteNotificationSoundProviding = UserDefaultsRemoteNotificationSoundProvider(userDefaults: userDefaults)
		remoteNotificationSoundProviding.setRemoteNotificationSound(remoteNotificationSoundProviding.remoteNotificationSound)

        userDefaults.set(true, forKey: UserDefaultsWitnessedTutorialPushPermissionsRequest.WitnessedTutorialPushPermissionsRequestKey)
    }

}
