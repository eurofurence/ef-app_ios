import Eurofurence
import EurofurenceModel
import XCTest

class MessageContentRouteTests: XCTestCase {
    
    func testShowsDetailContentController() {
        let message = MessageIdentifier.random
        let content = MessageContentRepresentation(identifier: message)
        let messageModuleFactory = StubMessageDetailComponentFactory()
        let contentWireframe = CapturingContentWireframe()
        let route = MessageContentRoute(
            messageModuleFactory: messageModuleFactory,
            contentWireframe: contentWireframe
        )
        
        route.route(content)
        
        XCTAssertEqual(message, messageModuleFactory.capturedMessage)
        XCTAssertEqual(messageModuleFactory.stubInterface, contentWireframe.replacedDetailContentController)
    }

}
