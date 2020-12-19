import Eurofurence
import UIKit
import XCTest

class ContentWireframeDecoratorTests: XCTestCase {
    
    private(set) var spyingWireframe: CapturingContentWireframe!
    
    override func setUp() {
        super.setUp()
        spyingWireframe = CapturingContentWireframe()
    }
    
    func testShowingPrimary() {
        let decorator = makeContentWireframe()
        let viewController = UIViewController()
        decorator.presentPrimaryContentController(viewController)
        
        XCTAssertEqual(viewController, spyingWireframe.presentedPrimaryContentController)
    }
    
    func testShowingDetail() {
        let decorator = makeContentWireframe()
        let viewController = UIViewController()
        decorator.presentDetailContentController(viewController)
        
        XCTAssertEqual(viewController, spyingWireframe.presentedDetailContentController)
    }
    
    func testReplacingDetail() {
        let decorator = makeContentWireframe()
        let viewController = UIViewController()
        decorator.replaceDetailContentController(viewController)
        
        XCTAssertEqual(viewController, spyingWireframe.replacedDetailContentController)
    }
    
    func makeContentWireframe() -> ContentWireframe {
        ContentWireframeDecorator(decoratedWireframe: spyingWireframe)
    }

}
