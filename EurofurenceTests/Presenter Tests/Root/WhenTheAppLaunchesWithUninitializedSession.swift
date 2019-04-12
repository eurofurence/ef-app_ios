@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenTheAppLaunchesWithUninitializedSession: XCTestCase {

    func testTheAppShouldFollowTheTutorialPathway() {
        let context = RootModuleTestBuilder().with(storeState: .uninitialized).build()

        XCTAssertTrue(context.delegate.toldTutorialShouldBePresented)
        XCTAssertFalse(context.delegate.toldStoreShouldRefresh)
        XCTAssertFalse(context.delegate.toldPrincipleModuleShouldBePresented)
    }

}
