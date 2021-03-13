import EurofurenceApplication
import EurofurenceModel
import XCTest

class UserDefaultsReviewPromptAppVersionRepositoryTests: XCTestCase {

    func testSavingVersionLoadsItLater() {
        let defaults = UserDefaults()
        var repository = UserDefaultsReviewPromptAppVersionRepository(userDefaults: defaults)
        let version = String.random
        repository.setLastPromptedAppVersion(version)
        repository = UserDefaultsReviewPromptAppVersionRepository(userDefaults: defaults)

        XCTAssertEqual(version, repository.lastPromptedAppVersion)
    }

}
