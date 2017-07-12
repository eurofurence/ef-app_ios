//
//  UserDefaultsAcknowledgedPushPermissionsRequestTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class UserDefaultsAcknowledgedPushPermissionsRequestTests: XCTestCase {
    
    var defaults: UserDefaults!
    var acknowledgedPushPermissionsProvider: UserDefaultsAcknowledgedPushPermissionsRequest!

    override func setUp() {
        super.setUp()

        defaults = UserDefaults()
        acknowledgedPushPermissionsProvider = UserDefaultsAcknowledgedPushPermissionsRequest(userDefaults: defaults)

        removeValueForAcknowledgedPushPermissionsRequestKeyFromDefaults()
    }

    private func removeValueForAcknowledgedPushPermissionsRequestKeyFromDefaults() {
        defaults.removeObject(forKey: UserDefaultsAcknowledgedPushPermissionsRequest.AcknowledgedPushRequestKey)
    }

    func testUserDefaultsWithoutValueForFirstTimeStateDefaultShouldIndicateAppNotOpenedBefore() {
        XCTAssertFalse(acknowledgedPushPermissionsProvider.pushPermissionsAcknowledged)
    }

    func testUserDefaultsWithTrueValueForFirstTimeStateKeyShouldIndicateAppOpenedBefore() {
        defaults.set(true, forKey: UserDefaultsAcknowledgedPushPermissionsRequest.AcknowledgedPushRequestKey)
        XCTAssertTrue(acknowledgedPushPermissionsProvider.pushPermissionsAcknowledged)
    }

    func testUserDefaultsWithFalseValueForFirstTimeStateKeyShouldIndicateAppNotOpenedBefore() {
        defaults.set(false, forKey: UserDefaultsAcknowledgedPushPermissionsRequest.AcknowledgedPushRequestKey)
        XCTAssertFalse(acknowledgedPushPermissionsProvider.pushPermissionsAcknowledged)
    }

    func testTellingProviderToMakeTutorialAsCompletedShouldSetAppropriateDefault() {
        defaults.set(false, forKey: UserDefaultsAcknowledgedPushPermissionsRequest.AcknowledgedPushRequestKey)
        acknowledgedPushPermissionsProvider.markPushPermissionsAsAcknowledged()

        XCTAssertTrue(defaults.bool(forKey: UserDefaultsAcknowledgedPushPermissionsRequest.AcknowledgedPushRequestKey))
    }
    
}
