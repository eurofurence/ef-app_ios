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
    var witnessedTutorialPushPermissionsRequestProvider: UserDefaultsWitnessedSystemPushPermissionsRequest!

    override func setUp() {
        super.setUp()

        defaults = UserDefaults()
        witnessedTutorialPushPermissionsRequestProvider = UserDefaultsWitnessedSystemPushPermissionsRequest(userDefaults: defaults)

        removeValueForOptedIntoPushNotificationsRequestKeyFromDefaults()
    }

    private func removeValueForOptedIntoPushNotificationsRequestKeyFromDefaults() {
        defaults.removeObject(forKey: UserDefaultsWitnessedSystemPushPermissionsRequest.WitnessedSystemPushRequest)
    }

    func testUserDefaultsWithoutValueForFirstTimeStateDefaultShouldIndicateAppNotOpenedBefore() {
        XCTAssertFalse(witnessedTutorialPushPermissionsRequestProvider.requestedPushNotificationAuthorization)
    }

    func testUserDefaultsWithTrueValueForFirstTimeStateKeyShouldIndicateAppOpenedBefore() {
        defaults.set(true, forKey: UserDefaultsWitnessedSystemPushPermissionsRequest.WitnessedSystemPushRequest)
        XCTAssertTrue(witnessedTutorialPushPermissionsRequestProvider.requestedPushNotificationAuthorization)
    }

    func testUserDefaultsWithFalseValueForFirstTimeStateKeyShouldIndicateAppNotOpenedBefore() {
        defaults.set(false, forKey: UserDefaultsWitnessedSystemPushPermissionsRequest.WitnessedSystemPushRequest)
        XCTAssertFalse(witnessedTutorialPushPermissionsRequestProvider.requestedPushNotificationAuthorization)
    }

    func testTellingProviderToMakeTutorialAsCompletedShouldSetAppropriateDefault() {
        defaults.set(false, forKey: UserDefaultsWitnessedSystemPushPermissionsRequest.WitnessedSystemPushRequest)
        witnessedTutorialPushPermissionsRequestProvider.attemptedPushAuthorizationRequest()

        XCTAssertTrue(defaults.bool(forKey: UserDefaultsWitnessedSystemPushPermissionsRequest.WitnessedSystemPushRequest))
    }
    
}
