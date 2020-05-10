@testable import Eurofurence
import EurofurenceModel
import XCTest

class BeforeDealerDetailSceneLoads_DealerDetailPresenterShould: XCTestCase {

    func testNotBindOntoTheScene() {
        let context = DealerDetailPresenterTestBuilder().build()
        XCTAssertNil(context.scene.boundNumberOfComponents)
    }

}
