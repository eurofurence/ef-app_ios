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
        userDefaults = UserDefaults(suiteName: .random).unsafelyUnwrapped
        prepareSystemUnderTest()
    }
    
    private func prepareSystemUnderTest() {
        forceRefreshRequired = UserDefaultsForceRefreshRequired(
            userDefaults: userDefaults,
            versionProviding: versionProviding
        )
    }

    func testNoSavedAppVersionRequiresForceRefresh() {
        XCTAssertTrue(forceRefreshRequired.isForceRefreshRequired)
    }

    func testLaunchingSameAppVersionDoesNotRequireForceRefresh() {
        XCTAssertTrue(forceRefreshRequired.isForceRefreshRequired)
        prepareSystemUnderTest()
        XCTAssertFalse(forceRefreshRequired.isForceRefreshRequired)
    }

    func testLaunchingDifferentAppVersionsRequiresForceRefresh() {
        XCTAssertTrue(forceRefreshRequired.isForceRefreshRequired)
        versionProviding.version = .random
        prepareSystemUnderTest()
        XCTAssertTrue(forceRefreshRequired.isForceRefreshRequired)
    }

}
