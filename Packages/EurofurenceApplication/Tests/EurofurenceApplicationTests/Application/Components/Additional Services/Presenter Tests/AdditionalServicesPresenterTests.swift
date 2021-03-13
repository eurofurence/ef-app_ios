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
        let expectedIconData = UIImage(named: "Additional Services", in: .main, compatibleWith: nil)?.pngData()
        
        XCTAssertEqual(.services, context.scene.capturedShortTitle)
        XCTAssertEqual(.additionalServices, context.scene.capturedTitle)
        XCTAssertEqual(expectedIconData, context.scene.capturedIconData)
    }
    
    func testLoadTheAdditionalServiesEndpointFromTheRepository() {
        context.simulateSceneDidLoad()
        XCTAssertEqual(context.repository.urlRequest, context.scene.capturedURLRequest)
    }
    
}
