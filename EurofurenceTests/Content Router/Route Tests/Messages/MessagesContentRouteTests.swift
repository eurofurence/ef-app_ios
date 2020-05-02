import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class MessagesContentRouteTests: XCTestCase {
    
    var router: FakeContentRouter!
    var messagesModuleProviding: StubMessagesModuleFactory!
    var contentWireframe: CapturingContentWireframe!
    var delegate: CapturingMessagesModuleDelegate!
    var authenticationService: FakeAuthenticationService!
    var route: MessagesContentRoute!
    
    override func setUp() {
        super.setUp()
        
        router = FakeContentRouter()
        messagesModuleProviding = StubMessagesModuleFactory()
        contentWireframe = CapturingContentWireframe()
        delegate = CapturingMessagesModuleDelegate()
        authenticationService = FakeAuthenticationService(authState: .loggedIn(.random))
        route = MessagesContentRoute(
            router: router,
            messagesModuleProviding: messagesModuleProviding,
            contentWireframe: contentWireframe,
            authenticationService: authenticationService,
            delegate: delegate
        )
    }
    
    private func executeRoute() {
        route.route(MessagesContentRepresentation())
    }
    
    func testShowsMessagesContentControllerWhileAuthenticated() {
        authenticationService.notifyObserversUserDidLogin()
        executeRoute()
        
        XCTAssertEqual(messagesModuleProviding.stubInterface, contentWireframe.presentedMasterContentController)
    }
    
    func testLoginRequiredThenShowsModule() throws {
        authenticationService.notifyObserversUserDidLogout()
        executeRoute()

        let loginAction: LoginContentRepresentation = try router.unwrapRoutedContent()
        loginAction.completionHandler(true)
        
        XCTAssertEqual(messagesModuleProviding.stubInterface, contentWireframe.presentedMasterContentController)
    }
    
    func testLoginFailsDoesNotShowModule() throws {
        authenticationService.notifyObserversUserDidLogout()
        executeRoute()

        let loginAction: LoginContentRepresentation = try router.unwrapRoutedContent()
        loginAction.completionHandler(false)
        
        XCTAssertNil(contentWireframe.presentedMasterContentController)
    }
    
    func testPropogatesUserResolutionDelegateEvent() {
        executeRoute()
        
        var success = false
        messagesModuleProviding.simulateResolutionForUser({ success = $0 })
        delegate.resolveUser()
        
        XCTAssertTrue(success)
    }
    
    func testPropogatesMessageSelectionDelegateEvent() {
        executeRoute()
        
        let message = MessageIdentifier.random
        messagesModuleProviding.simulateMessagePresentationRequested(message)
        
        XCTAssertEqual(message, delegate.messageToShow)
    }
    
    func testPropogatesDismissalDelegateEvent() {
        executeRoute()
        messagesModuleProviding.simulateDismissalRequested()
        
        XCTAssertTrue(delegate.dismissed)
    }

}
