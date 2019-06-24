@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenAdditionalServicesSceneLoads_PresenterShould: XCTestCase {

    func testTellTheSceneToLoadTheURLFromTheRepository() {
        let context = AdditionalServicesPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        
        XCTAssertEqual(context.repository.urlRequest, context.scene.capturedURLRequest)
    }

}
