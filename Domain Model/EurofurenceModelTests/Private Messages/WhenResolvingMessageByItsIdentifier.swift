import EurofurenceModel
import XCTest

class WhenResolvingMessageByItsIdentifier: XCTestCase {

    func testTheMessageIsResolved() {
        let context = EurofurenceSessionTestBuilder().loggedInWithValidCredential().build()
        let characteristics = MessageCharacteristics.random
        context.privateMessagesService.refreshMessages()
        context.api.simulateMessagesResponse(response: [characteristics])
        let identifier = MessageIdentifier(characteristics.identifier)
        let entity = context.privateMessagesService.fetchMessage(identifiedBy: identifier)
        
        MessageAssertion().assertMessage(entity, characterisedBy: characteristics)
    }

}
