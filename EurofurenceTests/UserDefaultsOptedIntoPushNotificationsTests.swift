//
//  UserDefaultsOptedIntoPushNotificationsTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class UserDefaultsOptedIntoPushNotificationsTests: XCTestCase {
    
    var defaults: UserDefaults!
    var acknowledgedPushPermissionsProvider: UserDefaultsOptedIntoPushNotifications!

    override func setUp() {
        super.setUp()

        defaults = UserDefaults()
        acknowledgedPushPermissionsProvider = UserDefaultsOptedIntoPushNotifications(userDefaults: defaults)

        removeValueForOptedIntoPushNotificationsRequestKeyFromDefaults()
    }

    private func removeValueForOptedIntoPushNotificationsRequestKeyFromDefaults() {
        defaults.removeObject(forKey: UserDefaultsOptedIntoPushNotifications.OptedIntoPushKey)
    }

    func testUserDefaultsWithoutValueForFirstTimeStateDefaultShouldIndicateAppNotOpenedBefore() {
        XCTAssertFalse(acknowledgedPushPermissionsProvider.userOptedIntoPush)
    }

    func testUserDefaultsWithTrueValueForFirstTimeStateKeyShouldIndicateAppOpenedBefore() {
        defaults.set(true, forKey: UserDefaultsOptedIntoPushNotifications.OptedIntoPushKey)
        XCTAssertTrue(acknowledgedPushPermissionsProvider.userOptedIntoPush)
    }

    func testUserDefaultsWithFalseValueForFirstTimeStateKeyShouldIndicateAppNotOpenedBefore() {
        defaults.set(false, forKey: UserDefaultsOptedIntoPushNotifications.OptedIntoPushKey)
        XCTAssertFalse(acknowledgedPushPermissionsProvider.userOptedIntoPush)
    }

    func testTellingProviderToMakeTutorialAsCompletedShouldSetAppropriateDefault() {
        defaults.set(false, forKey: UserDefaultsOptedIntoPushNotifications.OptedIntoPushKey)
        acknowledgedPushPermissionsProvider.markUserOptedIntoPushNotifications()

        XCTAssertTrue(defaults.bool(forKey: UserDefaultsOptedIntoPushNotifications.OptedIntoPushKey))
    }
    
}
