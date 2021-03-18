import ContentController
import XCTest
import XCTEurofurenceModel

class ContentSceneControllerTests: XCTestCase {
    
    func testUninitializedStateShowsTutorial() {
        let sessionState = ControllableSessionStateService()
        sessionState.simulatedState = .uninitialized
        let scene = CapturingContentBootstrappingScene()
        _ = ContentSceneController(sessionState: sessionState, scene: scene)
        
        XCTAssertEqual(.tutorial, scene.visibleScene)
    }
    
    func testStaleStateShowsPreloading() {
        let sessionState = ControllableSessionStateService()
        sessionState.simulatedState = .stale
        let scene = CapturingContentBootstrappingScene()
        _ = ContentSceneController(sessionState: sessionState, scene: scene)

        XCTAssertEqual(.preloading, scene.visibleScene)
    }

    func testInitializedShowsContent() {
        let sessionState = ControllableSessionStateService()
        sessionState.simulatedState = .initialized
        let scene = CapturingContentBootstrappingScene()
        _ = ContentSceneController(sessionState: sessionState, scene: scene)

        XCTAssertEqual(.content, scene.visibleScene)
    }

}
