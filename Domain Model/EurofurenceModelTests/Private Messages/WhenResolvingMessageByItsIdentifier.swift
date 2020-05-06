import EurofurenceModel
import XCTest

class WhenResolvingMessageByItsIdentifier: XCTestCase {

    func testTheMessageIsResolved() throws {
        let context = EurofurenceSessionTestBuilder().loggedInWithValidCredential().build()
        let characteristics = MessageCharacteristics.random
        context.privateMessagesService.refreshMessages()
        context.api.simulateMessagesResponse(response: [characteristics])
        let identifier = MessageIdentifier(characteristics.identifier)
        
        var message: Message?
        context.privateMessagesService.fetchMessage(identifiedBy: identifier) { message = try? $0.get() }
        
        let entity = try XCTUnwrap(message)
        
        MessageAssertion().assertMessage(entity, characterisedBy: characteristics)
    }

}
