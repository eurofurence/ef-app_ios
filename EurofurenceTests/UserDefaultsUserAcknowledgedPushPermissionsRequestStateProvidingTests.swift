@testable import Eurofurence
import EurofurenceModel
import XCTest

class UserDefaultsWitnessedTutorialPushPermissionsRequestTests: XCTestCase {

    var defaults: UserDefaults!
    var witnessedTutorialPushPermissionsRequestProvider: UserDefaultsWitnessedTutorialPushPermissionsRequest!

    override func setUp() {
        super.setUp()

        defaults = UserDefaults()
        witnessedTutorialPushPermissionsRequestProvider = UserDefaultsWitnessedTutorialPushPermissionsRequest(userDefaults: defaults)

        removeValueForWitnessedTutorialPushPermissionsRequestKeyFromDefaults()
    }

    private func removeValueForWitnessedTutorialPushPermissionsRequestKeyFromDefaults() {
        defaults.removeObject(forKey: UserDefaultsWitnessedTutorialPushPermissionsRequest.WitnessedTutorialPushPermissionsRequestKey)
    }

    func testUserDefaultsWithoutValueForFirstTimeStateDefaultShouldIndicateAppNotOpenedBefore() {
        XCTAssertFalse(witnessedTutorialPushPermissionsRequestProvider.witnessedTutorialPushPermissionsRequest)
    }

    func testUserDefaultsWithTrueValueForFirstTimeStateKeyShouldIndicateAppOpenedBefore() {
        defaults.set(true, forKey: UserDefaultsWitnessedTutorialPushPermissionsRequest.WitnessedTutorialPushPermissionsRequestKey)
        XCTAssertTrue(witnessedTutorialPushPermissionsRequestProvider.witnessedTutorialPushPermissionsRequest)
    }

    func testUserDefaultsWithFalseValueForFirstTimeStateKeyShouldIndicateAppNotOpenedBefore() {
        defaults.set(false, forKey: UserDefaultsWitnessedTutorialPushPermissionsRequest.WitnessedTutorialPushPermissionsRequestKey)
        XCTAssertFalse(witnessedTutorialPushPermissionsRequestProvider.witnessedTutorialPushPermissionsRequest)
    }

    func testTellingProviderToMakeTutorialAsCompletedShouldSetAppropriateDefault() {
        defaults.set(false, forKey: UserDefaultsWitnessedTutorialPushPermissionsRequest.WitnessedTutorialPushPermissionsRequestKey)
        witnessedTutorialPushPermissionsRequestProvider.markWitnessedTutorialPushPermissionsRequest()

        XCTAssertTrue(defaults.bool(forKey: UserDefaultsWitnessedTutorialPushPermissionsRequest.WitnessedTutorialPushPermissionsRequestKey))
    }

}
