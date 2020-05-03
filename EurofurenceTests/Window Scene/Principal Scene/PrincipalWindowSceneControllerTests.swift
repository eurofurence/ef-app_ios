import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class PrincipalWindowSceneControllerTests: XCTestCase {
    
    func testDoesNotSetSceneBeforeEvents() {
        let sessionState = ControllableSessionStateService()
        let scene = CapturingPrincipalWindowScene()
        _ = PrincipalWindowSceneController(sessionState: sessionState, scene: scene)
        
        XCTAssertEqual(.none, scene.visibleScene)
    }
    
    func testUninitializedStateShowsTutorial() {
        let sessionState = ControllableSessionStateService()
        let scene = CapturingPrincipalWindowScene()
        _ = PrincipalWindowSceneController(sessionState: sessionState, scene: scene)
        sessionState.enterUninitializedState()
        
        XCTAssertEqual(.tutorial, scene.visibleScene)
    }
    
    func testStaleStateShowsPreloading() {
        let sessionState = ControllableSessionStateService()
        let scene = CapturingPrincipalWindowScene()
        _ = PrincipalWindowSceneController(sessionState: sessionState, scene: scene)
        sessionState.enterStaleState()

        XCTAssertEqual(.preloading, scene.visibleScene)
    }

    func testInitializedShowsContent() {
        let sessionState = ControllableSessionStateService()
        let scene = CapturingPrincipalWindowScene()
        _ = PrincipalWindowSceneController(sessionState: sessionState, scene: scene)
        sessionState.enterInitializedState()

        XCTAssertEqual(.content, scene.visibleScene)
    }

}
