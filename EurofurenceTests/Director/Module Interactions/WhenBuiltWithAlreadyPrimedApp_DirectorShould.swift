@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBuiltWithAlreadyPrimedApp_DirectorShould: XCTestCase {

    func testShowTheTabModule() {
        let context = ApplicationDirectorTestBuilder().build()
        context.rootModule.simulateAppReady()
        let tabModule = context.tabModule.stubInterface

        XCTAssertEqual(tabModule, context.windowWireframe.capturedRootInterface)
    }

}
