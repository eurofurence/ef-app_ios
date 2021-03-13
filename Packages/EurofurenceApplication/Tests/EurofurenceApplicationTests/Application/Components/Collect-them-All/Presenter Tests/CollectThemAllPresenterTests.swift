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
        let expectedIconData = UIImage(named: "Collectemall-50", in: .main, compatibleWith: nil)?.pngData()
        
        XCTAssertEqual(.collect, context.scene.capturedShortTitle)
        XCTAssertEqual(.collectThemAll, context.scene.capturedTitle)
        XCTAssertEqual(expectedIconData, context.scene.capturedIconData)
    }

}
