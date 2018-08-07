//
//  UserDefaultsForceRefreshRequired.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 07/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct UserDefaultsForceRefreshRequired: ForceRefreshRequired {

    private struct Keys {
        static let lastWitnessedAppVersionKey = "EFLastOpenedAppVersion"
    }

    var userDefaults: UserDefaults = .standard
    var versionProviding: AppVersionProviding = BundleAppVersionProviding()

    var isForceRefreshRequired: Bool {
        let forceRefreshRequired = userDefaults.string(forKey: Keys.lastWitnessedAppVersionKey) != versionProviding.version
        userDefaults.set(versionProviding.version, forKey: Keys.lastWitnessedAppVersionKey)

        return forceRefreshRequired
    }

}
