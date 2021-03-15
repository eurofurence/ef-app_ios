import EurofurenceApplication
import XCTest

class MoveToTabContentWireframeTests: ContentWireframeDecoratorTests {
    
    private var tabSwapper: CapturingTabSwapper!
    
    override func setUp() {
        super.setUp()
        
        tabSwapper = CapturingTabSwapper()
    }
    
    func testShowingDetailSwapsTab() {
        let wireframe = makeContentWireframe()
        let viewController = UIViewController()
        wireframe.presentDetailContentController(viewController)
        
        XCTAssertTrue(tabSwapper.didMoveToTab)
    }
    
    func testReplacingDetailSwapsTab() {
        let wireframe = makeContentWireframe()
        let viewController = UIViewController()
        wireframe.replaceDetailContentController(viewController)
        
        XCTAssertTrue(tabSwapper.didMoveToTab)
    }
    
    override func makeContentWireframe() -> ContentWireframe {
        MoveToTabContentWireframe(decoratedWireframe: spyingWireframe, tabSwapper: tabSwapper)
    }

}
