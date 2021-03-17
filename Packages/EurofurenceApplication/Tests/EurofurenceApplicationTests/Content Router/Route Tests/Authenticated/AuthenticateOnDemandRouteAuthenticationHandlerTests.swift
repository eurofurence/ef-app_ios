import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTComponentBase
import XCTest

class AuthenticateOnDemandRouteAuthenticationHandlerTests: XCTestCase {
    
    func testAlreadyAuthenticated() {
        let service = FakeAuthenticationService(authState: .loggedIn(.random))
        let router = FakeContentRouter()
        let handler = AuthenticateOnDemandRouteAuthenticationHandler(
            service: service,
            router: router
        )
        
        var authenticated: Bool?
        handler.authenticateRouteNow(completionHandler: { authenticated = $0 })
        
        XCTAssertEqual(true, authenticated)
        XCTAssertNil(router.erasedRoutedContent)
    }
    
    func testNotAuthenticated_AuthenticationFailure() throws {
        let service = FakeAuthenticationService(authState: .loggedOut)
        let router = FakeContentRouter()
        let handler = AuthenticateOnDemandRouteAuthenticationHandler(
            service: service,
            router: router
        )
        
        var authenticated: Bool?
        handler.authenticateRouteNow(completionHandler: { authenticated = $0 })
        
        let content: LoginContentRepresentation = try router.unwrapRoutedContent()
        content.completionHandler(false)
        
        XCTAssertEqual(false, authenticated)
    }
    
    func testNotAuthenticated_AuthenticationSuccess() throws {
        let service = FakeAuthenticationService(authState: .loggedOut)
        let router = FakeContentRouter()
        let handler = AuthenticateOnDemandRouteAuthenticationHandler(
            service: service,
            router: router
        )
        
        var authenticated: Bool?
        handler.authenticateRouteNow(completionHandler: { authenticated = $0 })
        
        let content: LoginContentRepresentation = try router.unwrapRoutedContent()
        content.completionHandler(true)
        
        XCTAssertEqual(true, authenticated)
    }

}
