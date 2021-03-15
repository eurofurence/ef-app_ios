import EurofurenceApplication
import EurofurenceModel
import XCTest

class CollectThemAllPresenterTests: XCTestCase {
    
    var context: CollectThemAllPresenterTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        context = CollectThemAllPresenterTestBuilder().build()
    }
    
    func testWaitForSceneToLoadBeforePerformingRequest() {
        XCTAssertNil(context.scene.capturedURLRequest)
        
        context.simulateSceneDidLoad()
        
        XCTAssertEqual(context.service.urlRequest, context.scene.capturedURLRequest)
    }

    func testReturnInterfaceFromSceneFactory() {
        XCTAssertEqual(context.scene, context.producedViewController)
    }

    func testBindTheCollectThemAllAttributes() {
        XCTAssertEqual(.collect, context.scene.capturedShortTitle)
        XCTAssertEqual(.collectThemAll, context.scene.capturedTitle)
        XCTAssertNotNil(context.scene.capturedIconData)
    }

}
