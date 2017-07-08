//
//  UserDefaultsFirstTimeLaunchStateProviderTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import XCTest

struct UserDefaultsFirstTimeLaunchStateProvider: FirstTimeLaunchStateProviding {

    static let LaunchKey = "Eurofurence.FirstTimeLaunch"

    var userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    var userHasOpenedAppBefore: Bool {
        return userDefaults.bool(forKey: UserDefaultsFirstTimeLaunchStateProvider.LaunchKey)
    }

}

class UserDefaultsFirstTimeLaunchStateProviderTests: XCTestCase {

    var defaults: UserDefaults!
    var launchStateProvider: UserDefaultsFirstTimeLaunchStateProvider!

    override func setUp() {
        super.setUp()

        defaults = UserDefaults()
        launchStateProvider = UserDefaultsFirstTimeLaunchStateProvider(userDefaults: defaults)

        removeValueForLaunchKeyFromDefaults()
    }

    private func removeValueForLaunchKeyFromDefaults() {
        defaults.removeObject(forKey: UserDefaultsFirstTimeLaunchStateProvider.LaunchKey)
    }
    
    func testUserDefaultsWithoutValueForFirstTimeStateDefaultShouldIndicateAppNotOpenedBefore() {
        XCTAssertFalse(launchStateProvider.userHasOpenedAppBefore)
    }

    func testUserDefaultsWithTrueValueForFirstTimeStateKeyShouldIndicateAppOpenedBefore() {
        defaults.set(true, forKey: UserDefaultsFirstTimeLaunchStateProvider.LaunchKey)
        XCTAssertTrue(launchStateProvider.userHasOpenedAppBefore)
    }

    func testUserDefaultsWithFalseValueForFirstTimeStateKeyShouldIndicateAppNotOpenedBefore() {
        defaults.set(false, forKey: UserDefaultsFirstTimeLaunchStateProvider.LaunchKey)
        XCTAssertFalse(launchStateProvider.userHasOpenedAppBefore)
    }
    
}
