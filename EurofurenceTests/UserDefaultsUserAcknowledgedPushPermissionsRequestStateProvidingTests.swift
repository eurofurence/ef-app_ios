//
//  UserDefaultsUserAcknowledgedPushPermissionsRequestStateProvidingTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class UserDefaultsUserAcknowledgedPushPermissionsRequestStateProvidingTests: XCTestCase {
    
    var defaults: UserDefaults!
    var acknowledgedPushPermissionsProvider: UserDefaultsUserAcknowledgedPushPermissionsRequestStateProviding!

    override func setUp() {
        super.setUp()

        defaults = UserDefaults()
        acknowledgedPushPermissionsProvider = UserDefaultsUserAcknowledgedPushPermissionsRequestStateProviding(userDefaults: defaults)

        removeValueForAcknowledgedPushPermissionsRequestKeyFromDefaults()
    }

    private func removeValueForAcknowledgedPushPermissionsRequestKeyFromDefaults() {
        defaults.removeObject(forKey: UserDefaultsUserAcknowledgedPushPermissionsRequestStateProviding.AcknowledgedPushRequestKey)
    }

    func testUserDefaultsWithoutValueForFirstTimeStateDefaultShouldIndicateAppNotOpenedBefore() {
        XCTAssertFalse(acknowledgedPushPermissionsProvider.userHasAcknowledgedRequestForPushPermissions)
    }

    func testUserDefaultsWithTrueValueForFirstTimeStateKeyShouldIndicateAppOpenedBefore() {
        defaults.set(true, forKey: UserDefaultsUserAcknowledgedPushPermissionsRequestStateProviding.AcknowledgedPushRequestKey)
        XCTAssertTrue(acknowledgedPushPermissionsProvider.userHasAcknowledgedRequestForPushPermissions)
    }

    func testUserDefaultsWithFalseValueForFirstTimeStateKeyShouldIndicateAppNotOpenedBefore() {
        defaults.set(false, forKey: UserDefaultsUserAcknowledgedPushPermissionsRequestStateProviding.AcknowledgedPushRequestKey)
        XCTAssertFalse(acknowledgedPushPermissionsProvider.userHasAcknowledgedRequestForPushPermissions)
    }

    func testTellingProviderToMakeTutorialAsCompletedShouldSetAppropriateDefault() {
        defaults.set(false, forKey: UserDefaultsUserAcknowledgedPushPermissionsRequestStateProviding.AcknowledgedPushRequestKey)
        acknowledgedPushPermissionsProvider.markUserAsAcknowledgingPushPermissionsRequest()

        XCTAssertTrue(defaults.bool(forKey: UserDefaultsUserAcknowledgedPushPermissionsRequestStateProviding.AcknowledgedPushRequestKey))
    }
    
}
