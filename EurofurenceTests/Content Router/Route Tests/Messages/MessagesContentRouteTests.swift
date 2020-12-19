import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class MessagesContentRouteTests: XCTestCase {
    
    var messagesComponentFactory: StubMessagesComponentFactory!
    var contentWireframe: CapturingContentWireframe!
    var delegate: CapturingMessagesComponentDelegate!
    var route: MessagesContentRoute!
    
    override func setUp() {
        super.setUp()
        
        messagesComponentFactory = StubMessagesComponentFactory()
        contentWireframe = CapturingContentWireframe()
        delegate = CapturingMessagesComponentDelegate()
        route = MessagesContentRoute(
            messagesComponentFactory: messagesComponentFactory,
            contentWireframe: contentWireframe,
            delegate: delegate
        )
        
        route.route(MessagesContentRepresentation())
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
