import ComponentBase
import UIKit
import XCTest

open class ContentWireframeDecoratorTests: XCTestCase {
    
    public private(set) var spyingWireframe: CapturingContentWireframe!
    
    override open func setUp() {
        super.setUp()
        spyingWireframe = CapturingContentWireframe()
    }
    
    public func testShowingPrimary() {
        let decorator = makeContentWireframe()
        let viewController = UIViewController()
        decorator.presentPrimaryContentController(viewController)
        
        XCTAssertEqual(viewController, spyingWireframe.presentedPrimaryContentController)
    }
    
    public func testShowingDetail() {
        let decorator = makeContentWireframe()
        let viewController = UIViewController()
        decorator.presentDetailContentController(viewController)
        
        XCTAssertEqual(viewController, spyingWireframe.presentedDetailContentController)
    }
    
    public func testReplacingDetail() {
        let decorator = makeContentWireframe()
        let viewController = UIViewController()
        decorator.replaceDetailContentController(viewController)
        
        XCTAssertEqual(viewController, spyingWireframe.replacedDetailContentController)
    }
    
    open func makeContentWireframe() -> ContentWireframe {
        ContentWireframeDecorator(decoratedWireframe: spyingWireframe)
    }

}
