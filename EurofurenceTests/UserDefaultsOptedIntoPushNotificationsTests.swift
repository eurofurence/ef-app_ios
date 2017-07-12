//
//  UserDefaultsWitnessedSystemPushPermissionsRequestTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class UserDefaultsWitnessedSystemPushPermissionsRequestTests: XCTestCase {
    
    var defaults: UserDefaults!
    var acknowledgedPushPermissionsProvider: UserDefaultsWitnessedSystemPushPermissionsRequest!

    override func setUp() {
        super.setUp()

        defaults = UserDefaults()
        acknowledgedPushPermissionsProvider = UserDefaultsWitnessedSystemPushPermissionsRequest(userDefaults: defaults)

        removeValueForOptedIntoPushNotificationsRequestKeyFromDefaults()
    }

    private func removeValueForOptedIntoPushNotificationsRequestKeyFromDefaults() {
        defaults.removeObject(forKey: UserDefaultsWitnessedSystemPushPermissionsRequest.WitnessedSystemPushRequest)
    }

    func testUserDefaultsWithoutValueForFirstTimeStateDefaultShouldIndicateAppNotOpenedBefore() {
        XCTAssertFalse(acknowledgedPushPermissionsProvider.witnessedSystemPushPermissions)
    }

    func testUserDefaultsWithTrueValueForFirstTimeStateKeyShouldIndicateAppOpenedBefore() {
        defaults.set(true, forKey: UserDefaultsWitnessedSystemPushPermissionsRequest.WitnessedSystemPushRequest)
        XCTAssertTrue(acknowledgedPushPermissionsProvider.witnessedSystemPushPermissions)
    }

    func testUserDefaultsWithFalseValueForFirstTimeStateKeyShouldIndicateAppNotOpenedBefore() {
        defaults.set(false, forKey: UserDefaultsWitnessedSystemPushPermissionsRequest.WitnessedSystemPushRequest)
        XCTAssertFalse(acknowledgedPushPermissionsProvider.witnessedSystemPushPermissions)
    }

    func testTellingProviderToMakeTutorialAsCompletedShouldSetAppropriateDefault() {
        defaults.set(false, forKey: UserDefaultsWitnessedSystemPushPermissionsRequest.WitnessedSystemPushRequest)
        acknowledgedPushPermissionsProvider.markUserWitnessedSystemPushPermissionsRequest()

        XCTAssertTrue(defaults.bool(forKey: UserDefaultsWitnessedSystemPushPermissionsRequest.WitnessedSystemPushRequest))
    }
    
}
