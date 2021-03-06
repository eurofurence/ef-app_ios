import Eurofurence
import EurofurenceModel
import XCTest

class UserDefaultsTutorialStateProviderTests: XCTestCase {

    var defaults: UserDefaults!
    var launchStateProvider: UserDefaultsTutorialStateProvider!

    override func setUp() {
        super.setUp()

        defaults = UserDefaults()
        launchStateProvider = UserDefaultsTutorialStateProvider(userDefaults: defaults)

        removeValueForFinishedTutorialKeyFromDefaults()
    }

    private func removeValueForFinishedTutorialKeyFromDefaults() {
        defaults.removeObject(forKey: UserDefaultsTutorialStateProvider.FinishedTutorialKey)
    }

    func testUserDefaultsWithoutValueForFirstTimeStateDefaultShouldIndicateAppNotOpenedBefore() {
        XCTAssertFalse(launchStateProvider.userHasCompletedTutorial)
    }

    func testUserDefaultsWithTrueValueForFirstTimeStateKeyShouldIndicateAppOpenedBefore() {
        defaults.set(true, forKey: UserDefaultsTutorialStateProvider.FinishedTutorialKey)

        XCTAssertTrue(launchStateProvider.userHasCompletedTutorial)
    }

    func testUserDefaultsWithFalseValueForFirstTimeStateKeyShouldIndicateAppNotOpenedBefore() {
        defaults.set(false, forKey: UserDefaultsTutorialStateProvider.FinishedTutorialKey)

        XCTAssertFalse(launchStateProvider.userHasCompletedTutorial)
    }

    func testTellingProviderToMakeTutorialAsCompletedShouldSetAppropriateDefault() {
        defaults.set(false, forKey: UserDefaultsTutorialStateProvider.FinishedTutorialKey)
        launchStateProvider.markTutorialAsComplete()

        XCTAssertTrue(defaults.bool(forKey: UserDefaultsTutorialStateProvider.FinishedTutorialKey))
    }

}
