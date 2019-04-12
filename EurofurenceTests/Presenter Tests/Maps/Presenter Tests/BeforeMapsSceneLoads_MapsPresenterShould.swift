@testable import Eurofurence
import EurofurenceModel
import XCTest

class BeforeMapsSceneLoads_MapsPresenterShould: XCTestCase {

    func testNotPerformAnySceneBindings() {
        let context = MapsPresenterTestBuilder().build()
        XCTAssertNil(context.scene.boundNumberOfMaps)
    }

}
