//
//  UserDefaultsForceRefreshRequired.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 07/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public struct UserDefaultsForceRefreshRequired: ForceRefreshRequired {

    private struct Keys {
        static let lastWitnessedAppVersionKey = "EFLastOpenedAppVersion"
    }

    var userDefaults: UserDefaults = .standard
    var versionProviding: AppVersionProviding = BundleAppVersionProviding.shared

    public init(userDefaults: UserDefaults = .standard, versionProviding: AppVersionProviding = BundleAppVersionProviding.shared) {
        self.userDefaults = userDefaults
        self.versionProviding = versionProviding
    }

    public var isForceRefreshRequired: Bool {
        let forceRefreshRequired = userDefaults.string(forKey: Keys.lastWitnessedAppVersionKey) != versionProviding.version
        userDefaults.set(versionProviding.version, forKey: Keys.lastWitnessedAppVersionKey)

        return forceRefreshRequired
    }
    
    public func markForceRefreshNoLongerRequired() {
        
    }

}
