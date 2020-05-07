import EurofurenceModel
import XCTest

class WhenResolvingMessageByItsIdentifier: XCTestCase {

    func testMessageAvailable() throws {
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
    
    func testMessageUnavailable_ThenFoundDuringLoad() throws {
        let context = EurofurenceSessionTestBuilder().loggedInWithValidCredential().build()
        let characteristics = MessageCharacteristics.random
        let identifier = MessageIdentifier(characteristics.identifier)
        
        var message: Message?
        context.privateMessagesService.fetchMessage(identifiedBy: identifier) { message = try? $0.get() }
        context.api.simulateMessagesResponse(response: [characteristics])
        
        let entity = try XCTUnwrap(message)
        
        MessageAssertion().assertMessage(entity, characterisedBy: characteristics)
    }
    
    func testMessageUnavailable_LoadFails() throws {
        let context = EurofurenceSessionTestBuilder().loggedInWithValidCredential().build()
        let characteristics = MessageCharacteristics.random
        let identifier = MessageIdentifier(characteristics.identifier)
        
        var error: Error?
        context.privateMessagesService.fetchMessage(identifiedBy: identifier) { (result) in
            if case .failure(let serviceError) = result {
                error = serviceError
            }
        }
        
        context.api.simulateMessagesFailure()
        
        let castedError = try XCTUnwrap(error as? PrivateMessageError)
        
        XCTAssertEqual(.loadingMessagesFailed, castedError)
    }
    
    func testMessageUnavailable_NotFoundAfterLoad() throws {
        let context = EurofurenceSessionTestBuilder().loggedInWithValidCredential().build()
        
        let identifier = MessageIdentifier.random
        
        var error: Error?
        context.privateMessagesService.fetchMessage(identifiedBy: identifier) { (result) in
            if case .failure(let serviceError) = result {
                error = serviceError
            }
        }
        
        let anotherMessage = MessageCharacteristics.random
        context.api.simulateMessagesResponse(response: [anotherMessage])
        
        let castedError = try XCTUnwrap(error as? PrivateMessageError)
        
        XCTAssertEqual(.noMessageFound, castedError)
    }

}
