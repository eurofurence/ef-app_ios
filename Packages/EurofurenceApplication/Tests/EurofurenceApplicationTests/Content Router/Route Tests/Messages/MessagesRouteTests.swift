import EurofurenceApplication
import EurofurenceModel
import XCTComponentBase
import XCTest
import XCTEurofurenceModel

class MessagesRouteTests: XCTestCase {
    
    var messagesComponentFactory: StubMessagesComponentFactory!
    var contentWireframe: CapturingContentWireframe!
    var delegate: CapturingMessagesComponentDelegate!
    var route: MessagesRoute!
    
    override func setUp() {
        super.setUp()
        
        messagesComponentFactory = StubMessagesComponentFactory()
        contentWireframe = CapturingContentWireframe()
        delegate = CapturingMessagesComponentDelegate()
        route = MessagesRoute(
            messagesComponentFactory: messagesComponentFactory,
            contentWireframe: contentWireframe,
            delegate: delegate
        )
        
        route.route(MessagesRouteable())
    }
    
    func testShowsMessagesContentController() {
        XCTAssertEqual(messagesComponentFactory.stubInterface, contentWireframe.presentedPrimaryContentController)
    }
    
    func testPropogatesMessageSelectionDelegateEvent() {
        let message = MessageIdentifier.random
        messagesComponentFactory.simulateMessagePresentationRequested(message)
        
        XCTAssertEqual(message, delegate.messageToShow)
    }
    
    func testPropogatesDismissalDelegateEvent() {
        messagesComponentFactory.simulateDismissalRequested()
        XCTAssertTrue(delegate.dismissed)
    }

}
