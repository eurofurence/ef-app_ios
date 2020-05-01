import Eurofurence
import EurofurenceModel
import XCTest

class NavigateFromMessagesToMessageTests: XCTestCase {
    
    func testRoutesToMessageContent() {
        let router = FakeContentRouter()
        let navigator = NavigateFromMessagesToMessage(router: router)
        let message = MessageIdentifier.random
        
        navigator.messagesModuleDidRequestPresentation(for: message)
        let expected = MessageContentRepresentation(identifier: message)
        
        router.assertRouted(to: expected)
    }

}
