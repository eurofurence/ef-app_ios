@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenTheAppLaunchesWithInitializedSession: XCTestCase {

    func testTheAppShouldFollowThePrincipleModulePathway() {
        let context = RootModuleTestBuilder().with(storeState: .initialized).build()

        XCTAssertFalse(context.delegate.toldStoreShouldRefresh)
        XCTAssertFalse(context.delegate.toldTutorialShouldBePresented)
        XCTAssertTrue(context.delegate.toldPrincipleModuleShouldBePresented)
    }

}
