//
//  UserDefaultsPreferences.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct UserDefaultsPreferences: UserPreferences {

    private let defaults = UserDefaults.standard

    private struct Keys {
        static var refreshStoreOnLaunchKey = "EFAutoRefreshDataStoreWhenAppDidLaunch"
    }

    init() {
        defaults.register(defaults: [Keys.refreshStoreOnLaunchKey: false])
    }

    var refreshStoreOnLaunch: Bool {
        return defaults.bool(forKey: Keys.refreshStoreOnLaunchKey)
    }

}
