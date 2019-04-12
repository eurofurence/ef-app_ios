@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBuiltWithAlreadyPrimedApp_DirectorShould: XCTestCase {

    func testShowTheTabModuleUsingDissolveTransition() {
        let context = ApplicationDirectorTestBuilder().build()
        context.rootModule.simulateAppReady()

        let navigationController = context.rootNavigationController
        let preloadModule = context.preloadModule.stubInterface
        let tabModule = context.tabModule.stubInterface
        let transition = navigationController.delegate?.navigationController?(navigationController, animationControllerFor: .push, from: preloadModule, to: tabModule)

        XCTAssertEqual([context.tabModule.stubInterface], context.rootNavigationController.viewControllers)
        XCTAssertTrue(transition is ViewControllerDissolveTransitioning)
    }

}
