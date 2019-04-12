@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenTheAppLaunchesWithStaleSession: XCTestCase {

    func testTheAppShouldFollowTheRefreshPathway() {
        let context = RootModuleTestBuilder().with(storeState: .stale).build()

        XCTAssertTrue(context.delegate.toldStoreShouldRefresh)
        XCTAssertFalse(context.delegate.toldTutorialShouldBePresented)
        XCTAssertFalse(context.delegate.toldPrincipleModuleShouldBePresented)
    }

}
