import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class UserDefaultsForceRefreshRequiredTests: XCTestCase {

    var versionProviding: StubAppVersionProviding!
    var userDefaults: UserDefaults!
    var forceRefreshRequired: UserDefaultsForceRefreshRequired!

    override func setUp() {
        super.setUp()

        versionProviding = StubAppVersionProviding(version: .random)
        userDefaults = unwrap(UserDefaults(suiteName: .random))
        forceRefreshRequired = UserDefaultsForceRefreshRequired(userDefaults: userDefaults, versionProviding: versionProviding)
    }

    func testNoSavedAppVersionRequiresForceRefresh() {
        XCTAssertTrue(forceRefreshRequired.isForceRefreshRequired)
    }

    func testLaunchingSameAppVersionDoesNotRequireForceRefresh() {
        XCTAssertTrue(forceRefreshRequired.isForceRefreshRequired)
        forceRefreshRequired = UserDefaultsForceRefreshRequired(userDefaults: userDefaults, versionProviding: versionProviding)
        XCTAssertFalse(forceRefreshRequired.isForceRefreshRequired)
    }

    func testLaunchingDifferentAppVersionsRequiresForceRefresh() {
        XCTAssertTrue(forceRefreshRequired.isForceRefreshRequired)
        versionProviding.version = .random
        forceRefreshRequired = UserDefaultsForceRefreshRequired(userDefaults: userDefaults, versionProviding: versionProviding)
        XCTAssertTrue(forceRefreshRequired.isForceRefreshRequired)
    }

}
