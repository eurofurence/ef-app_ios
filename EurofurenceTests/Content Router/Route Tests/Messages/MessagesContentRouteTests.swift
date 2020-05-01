import Eurofurence
import EurofurenceModel
import XCTest

class MessagesContentRouteTests: XCTestCase {
    
    var messagesModuleProviding: StubMessagesModuleFactory!
    var contentWireframe: CapturingContentWireframe!
    var delegate: CapturingMessagesModuleDelegate!
    var route: MessagesContentRoute!
    
    override func setUp() {
        super.setUp()
        
        messagesModuleProviding = StubMessagesModuleFactory()
        contentWireframe = CapturingContentWireframe()
        delegate = CapturingMessagesModuleDelegate()
        route = MessagesContentRoute(
            messagesModuleProviding: messagesModuleProviding,
            contentWireframe: contentWireframe,
            delegate: delegate
        )
        
        route.route(MessagesContentRepresentation())
    }
    
    func testShowsContentController() {
        XCTAssertEqual(messagesModuleProviding.stubInterface, contentWireframe.presentedMasterContentController)
    }
    
    func testPropogatesUserResolutionDelegateEvent() {
        var success = false
        messagesModuleProviding.simulateResolutionForUser({ success = $0 })
        delegate.resolveUser()
        
        XCTAssertTrue(success)
    }
    
    func testPropogatesMessageSelectionDelegateEvent() {
        let message = MessageIdentifier.random
        messagesModuleProviding.simulateMessagePresentationRequested(message)
        
        XCTAssertEqual(message, delegate.messageToShow)
    }
    
    func testPropogatesDismissalDelegateEvent() {
        messagesModuleProviding.simulateDismissalRequested()
        XCTAssertTrue(delegate.dismissed)
    }

}
