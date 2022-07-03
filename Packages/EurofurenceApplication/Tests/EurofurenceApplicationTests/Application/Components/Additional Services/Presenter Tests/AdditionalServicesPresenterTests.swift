import EurofurenceApplication
import EurofurenceModel
import XCTest

class AdditionalServicesPresenterTests: XCTestCase {
    
    var context: AdditionalServicesPresenterTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        context = AdditionalServicesPresenterTestBuilder().build()
    }
    
    func testReturnsInterfaceFromSceneFactory() {
        XCTAssertEqual(context.scene, context.producedViewController)
    }
    
    func testWaitForSceneToLoadBeforeFiringRequest() {
        XCTAssertNil(context.scene.capturedURLRequest)
    }
    
    func testApplyBindsExpectedSceneAttributes() {
        XCTAssertEqual(.services, context.scene.capturedShortTitle)
        XCTAssertEqual(.additionalServices, context.scene.capturedTitle)
    }
    
    func testLoadTheAdditionalServiesEndpointFromTheRepository() {
        context.simulateSceneDidLoad()
        XCTAssertEqual(context.repository.urlRequest, context.scene.capturedURLRequest)
    }
    
}
