@testable import Eurofurence
import EurofurenceModel
import XCTest

class BeforeAdditionalServicesSceneLoads_PresenterShould: XCTestCase {

    func testNotTellTheSceneToLoadAdditionalServices() {
        let context = AdditionalServicesPresenterTestBuilder().build()
        XCTAssertNil(context.scene.capturedURLRequest)
    }

}
