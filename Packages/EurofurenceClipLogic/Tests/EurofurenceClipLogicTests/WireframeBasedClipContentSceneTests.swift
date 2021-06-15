import EurofurenceClipLogic
import XCTest

class WireframeBasedClipContentSceneTests: XCTestCase {
    
    private var wireframe: CapturingReplaceRootWireframe!
    private var scheduleComponent: StubClipContentControllerFactory!
    private var dealersComponent: StubClipContentControllerFactory!
    private var scene: WireframeBasedClipContentScene!
    
    override func setUp() {
        super.setUp()
        
        wireframe = CapturingReplaceRootWireframe()
        scheduleComponent = StubClipContentControllerFactory()
        dealersComponent = StubClipContentControllerFactory()
        scene = WireframeBasedClipContentScene(
            wireframe: wireframe,
            scheduleComponent: scheduleComponent,
            dealersComponent: dealersComponent
        )
    }
    
    func testShowingEvents() {
        scene.prepareForShowingEvents()
        XCTAssertIdentical(scheduleComponent.contentController, wireframe.currentRoot)
    }
    
    func testShowingDealers() {
        scene.prepareForShowingDealers()
        XCTAssertIdentical(dealersComponent.contentController, wireframe.currentRoot)
    }
    
}
