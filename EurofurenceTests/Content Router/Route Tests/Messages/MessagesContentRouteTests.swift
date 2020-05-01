import Eurofurence
import EurofurenceModel
import XCTest

class MessagesContentRouteTests: XCTestCase {
    
    func testShowsContentController() {
        let content = MessagesContentRepresentation()
        let messagesModuleProviding = StubMessagesModuleFactory()
        let contentWireframe = CapturingContentWireframe()
        let route = MessagesContentRoute(
            messagesModuleProviding: messagesModuleProviding,
            contentWireframe: contentWireframe
        )
        
        route.route(content)
        
        XCTAssertEqual(messagesModuleProviding.stubInterface, contentWireframe.presentedMasterContentController)
    }

}
