import Eurofurence
import XCTest

class IntentContentRepresentationTests: ContentRepresentationTestCase {

    func testEvent() {
        let eventIntentDefinition = ViewEventIntentDefinition(identifier: .random, eventName: .random)
        let eventIntentDefinitionProviding = StubEventIntentDefinitionProviding(
            eventIntentDefinition: eventIntentDefinition
        )
        
        let contentRepresentation = IntentContentRepresentation(intent: eventIntentDefinitionProviding)
        let expected = EventContentRepresentation(identifier: eventIntentDefinition.identifier)
        
        assert(content: contentRepresentation, isDescribedAs: expected)
    }
    
    func testDealer() {
        let dealerIntentDefinition = ViewDealerIntentDefinition(identifier: .random, dealerName: .random)
        let dealerIntentDefinitionProviding = StubDealerIntentDefinitionProviding(
            dealerIntentDefinition: dealerIntentDefinition
        )
        
        let contentRepresentation = IntentContentRepresentation(intent: dealerIntentDefinitionProviding)
        let expected = DealerContentRepresentation(identifier: dealerIntentDefinition.identifier)
        
        assert(content: contentRepresentation, isDescribedAs: expected)
    }

}
