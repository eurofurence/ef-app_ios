@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenPreloadCompletes_DirectorShould: XCTestCase {

    func testShowTheTabModuleUsingDissolveTransition() {
        let context = ApplicationDirectorTestBuilder().build()
        context.rootModule.simulateTutorialShouldBePresented()
        context.tutorialModule.simulateTutorialFinished()
        context.preloadModule.simulatePreloadFinished()
        let tabModule = context.tabModule.stubInterface

        XCTAssertEqual(tabModule, context.windowWireframe.capturedRootInterface)
    }

}
