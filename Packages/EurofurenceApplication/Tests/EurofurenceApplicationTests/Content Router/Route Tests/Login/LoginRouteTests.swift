import EurofurenceApplication
import XCTComponentBase
import XCTest

class LoginRouteTests: XCTestCase {
    
    func testModallyShowsLoginContentController() {
        let content = LoginRouteable(completionHandler: { (_) in })
        let loginModuleFactory = StubLoginComponentFactory()
        let modalWireframe = CapturingModalWireframe()
        let route = LoginRoute(
            loginModuleFactory: loginModuleFactory,
            modalWireframe: modalWireframe
        )
        
        route.route(content)
        
        XCTAssertEqual(modalWireframe.presentedModalContentController, loginModuleFactory.stubInterface)
    }
    
    func testPropogatesCancellationEvent() {
        var didLogin: Bool?
        let content = LoginRouteable(completionHandler: { didLogin = $0 })
        
        let loginModuleFactory = StubLoginComponentFactory(
            stubInterface: AutomaticallyCompletesOperationsViewController()
        )
        
        let modalWireframe = CapturingModalWireframe()
        let route = LoginRoute(
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
        let content = LoginRouteable(completionHandler: { didLogin = $0 })
        
        let loginModuleFactory = StubLoginComponentFactory(
            stubInterface: AutomaticallyCompletesOperationsViewController()
        )
        
        let modalWireframe = CapturingModalWireframe()
        let route = LoginRoute(
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
