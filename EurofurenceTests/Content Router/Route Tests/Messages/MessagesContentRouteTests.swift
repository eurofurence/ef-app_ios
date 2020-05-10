import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class MessagesContentRouteTests: XCTestCase {
    
    var messagesComponentFactory: StubMessagesModuleFactory!
    var contentWireframe: CapturingContentWireframe!
    var delegate: CapturingMessagesComponentDelegate!
    var route: MessagesContentRoute!
    
    override func setUp() {
        super.setUp()
        
        messagesComponentFactory = StubMessagesModuleFactory()
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
        XCTAssertEqual(messagesComponentFactory.stubInterface, contentWireframe.presentedMasterContentController)
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
