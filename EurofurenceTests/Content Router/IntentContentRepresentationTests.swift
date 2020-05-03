import Eurofurence
import EurofurenceIntentDefinitions
import XCTest

class IntentContentRepresentationTests: XCTestCase {

    func testEvent() {
        let eventIntentDefinition = ViewEventIntentDefinition(identifier: .random, eventName: .random)
        let eventIntentDefinitionProviding = StubEventIntentDefinitionProviding(eventIntentDefinition: eventIntentDefinition)
        let contentRepresentation = IntentContentRepresentation(intent: eventIntentDefinitionProviding)
        let expected = EventContentRepresentation(identifier: eventIntentDefinition.identifier)
        
        let recipient = CapturingContentRepresentationRecipient()
        contentRepresentation.describe(to: recipient)
        XCTAssertEqual(expected.eraseToAnyContentRepresentation(), recipient.erasedRoutedContent)
    }
    
    func testDealer() {
        let dealerIntentDefinition = ViewDealerIntentDefinition(identifier: .random, dealerName: .random)
        let dealerIntentDefinitionProviding = StubDealerIntentDefinitionProviding(dealerIntentDefinition: dealerIntentDefinition)
        let contentRepresentation = IntentContentRepresentation(intent: dealerIntentDefinitionProviding)
        let expected = DealerContentRepresentation(identifier: dealerIntentDefinition.identifier)
        
        let recipient = CapturingContentRepresentationRecipient()
        contentRepresentation.describe(to: recipient)
        XCTAssertEqual(expected.eraseToAnyContentRepresentation(), recipient.erasedRoutedContent)
    }

}
