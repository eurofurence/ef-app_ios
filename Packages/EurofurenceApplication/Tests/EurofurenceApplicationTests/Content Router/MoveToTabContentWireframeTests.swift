import EurofurenceApplication
import XCTest

class MoveToTabContentWireframeTests: ContentWireframeDecoratorTests {
    
    private var tabSwapper: CapturingTabNavigator!
    
    override func setUp() {
        super.setUp()
        
        tabSwapper = CapturingTabNavigator()
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
