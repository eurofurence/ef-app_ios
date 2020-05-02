import Eurofurence
import XCTest

class LoginRouteTests: XCTestCase {
    
    func testModallyShowsLoginContentController() {
        let content = LoginContentRepresentation(completionHandler: { (_) in })
        let loginModuleFactory = StubLoginModuleFactory()
        let modalWireframe = CapturingModalWireframe()
        let route = LoginContentRoute(
            loginModuleFactory: loginModuleFactory,
            modalWireframe: modalWireframe
        )
        
        route.route(content)
        
        XCTAssertEqual(modalWireframe.presentedModalContentController, loginModuleFactory.stubInterface)
    }
    
    func testPropogatesCancellationEvent() {
        var didLogin: Bool?
        let content = LoginContentRepresentation(completionHandler: { didLogin = $0 })
        
        let loginModuleFactory = StubLoginModuleFactory()
        let modalWireframe = CapturingModalWireframe()
        let route = LoginContentRoute(
            loginModuleFactory: loginModuleFactory,
            modalWireframe: modalWireframe
        )
        
        route.route(content)
        
        XCTAssertFalse(loginModuleFactory.stubInterface.didDismissPresentedController)
        
        loginModuleFactory.simulateLoginCancelled()
        
        XCTAssertEqual(false, didLogin)
        XCTAssertTrue(loginModuleFactory.stubInterface.didDismissPresentedController)
    }
    
    func testPropogatesLoginSuccess() {
        var didLogin: Bool?
        let content = LoginContentRepresentation(completionHandler: { didLogin = $0 })
        
        let loginModuleFactory = StubLoginModuleFactory()
        let modalWireframe = CapturingModalWireframe()
        let route = LoginContentRoute(
            loginModuleFactory: loginModuleFactory,
            modalWireframe: modalWireframe
        )
        
        route.route(content)
        
        XCTAssertFalse(loginModuleFactory.stubInterface.didDismissPresentedController)
        
        loginModuleFactory.simulateLoginSucceeded()
        
        XCTAssertEqual(true, didLogin)
        XCTAssertTrue(loginModuleFactory.stubInterface.didDismissPresentedController)
    }

}
