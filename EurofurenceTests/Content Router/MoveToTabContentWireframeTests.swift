import Eurofurence
import XCTest

class MoveToTabContentWireframeTests: ContentWireframeDecoratorTests {
    
    private var tabSwapper: CapturingTabSwapper!
    
    override func setUp() {
        super.setUp()
        
        tabSwapper = CapturingTabSwapper()
    }
    
    func testSwapsTabThenRoutesToDealer() {
        let wireframe = makeContentWireframe()
        let viewController = UIViewController()
        wireframe.presentDetailContentController(viewController)
        
        XCTAssertTrue(tabSwapper.didMoveToTab)
    }
    
    override func makeContentWireframe() -> ContentWireframe {
        MoveToTabContentWireframe(decoratedWireframe: spyingWireframe, tabSwapper: tabSwapper)
    }

}
