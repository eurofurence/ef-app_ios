import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class PrincipalWindowSceneControllerTests: XCTestCase {
    
    func testUninitializedStateShowsTutorial() {
        let sessionState = ControllableSessionStateService()
        sessionState.simulatedState = .uninitialized
        let scene = CapturingPrincipalWindowScene()
        _ = PrincipalWindowSceneController(sessionState: sessionState, scene: scene)
        
        XCTAssertEqual(.tutorial, scene.visibleScene)
    }
    
    func testStaleStateShowsPreloading() {
        let sessionState = ControllableSessionStateService()
        sessionState.simulatedState = .stale
        let scene = CapturingPrincipalWindowScene()
        _ = PrincipalWindowSceneController(sessionState: sessionState, scene: scene)

        XCTAssertEqual(.preloading, scene.visibleScene)
    }

    func testInitializedShowsContent() {
        let sessionState = ControllableSessionStateService()
        sessionState.simulatedState = .initialized
        let scene = CapturingPrincipalWindowScene()
        _ = PrincipalWindowSceneController(sessionState: sessionState, scene: scene)

        XCTAssertEqual(.content, scene.visibleScene)
    }

}
