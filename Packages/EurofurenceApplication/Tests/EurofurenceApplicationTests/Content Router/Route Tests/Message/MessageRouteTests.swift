import EurofurenceApplication
import EurofurenceModel
import XCTComponentBase
import XCTest

class MessageRouteTests: XCTestCase {
    
    func testShowsDetailContentController() {
        let message = MessageIdentifier.random
        let content = MessageRouteable(identifier: message)
        let messageModuleFactory = StubMessageDetailComponentFactory()
        let contentWireframe = CapturingContentWireframe()
        let route = MessageRoute(
            messageModuleFactory: messageModuleFactory,
            contentWireframe: contentWireframe
        )
        
        route.route(content)
        
        XCTAssertEqual(message, messageModuleFactory.capturedMessage)
        XCTAssertEqual(messageModuleFactory.stubInterface, contentWireframe.replacedDetailContentController)
    }

}
