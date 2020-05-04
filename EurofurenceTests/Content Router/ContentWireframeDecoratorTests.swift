import Eurofurence
import UIKit
import XCTest

class ContentWireframeDecoratorTests: XCTestCase {
    
    private(set) var spyingWireframe: CapturingContentWireframe!
    
    override func setUp() {
        super.setUp()
        spyingWireframe = CapturingContentWireframe()
    }
    
    func testShowingMaster() {
        let decorator = makeContentWireframe()
        let viewController = UIViewController()
        decorator.presentMasterContentController(viewController)
        
        XCTAssertEqual(viewController, spyingWireframe.presentedMasterContentController)
    }
    
    func testShowingDetail() {
        let decorator = makeContentWireframe()
        let viewController = UIViewController()
        decorator.presentDetailContentController(viewController)
        
        XCTAssertEqual(viewController, spyingWireframe.presentedDetailContentController)
    }
    
    func makeContentWireframe() -> ContentWireframe {
        ContentWireframeDecorator(decoratedWireframe: spyingWireframe)
    }

}
