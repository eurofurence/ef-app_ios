@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBuildingDealerDetailModule: XCTestCase {

    func testTheSceneFromTheFactoryIsReturned() {
        let context = DealerDetailPresenterTestBuilder().build()
        XCTAssertEqual(context.scene, context.producedModuleViewController)
    }
    
    func testNoBindingsOccur() {
        let context = DealerDetailPresenterTestBuilder().build()
        XCTAssertNil(context.scene.boundNumberOfComponents)
    }

}
