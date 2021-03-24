import ComponentBase
import DealerComponent
import EventDetailComponent
import Foundation

public struct IntentContentRepresentation: ContentRepresentation {
    
    public var intent: AnyHashable
    
    public init(intent: AnyHashable) {
        self.intent = intent
    }
    
}

// MARK: - ContentRepresentationDescribing

extension IntentContentRepresentation: ContentRepresentationDescribing {
    
    public func describe(to recipient: ContentRepresentationRecipient) {
        if let eventDefinitionProviding = intent as? EventIntentDefinitionProviding,
           let eventDefinition = eventDefinitionProviding.eventIntentDefinition {
            let content = EventContentRepresentation(identifier: eventDefinition.identifier)
            recipient.receive(content)
        }
        
        if let dealerDefinitionProviding = intent as? DealerIntentDefinitionProviding,
           let dealerDefinition = dealerDefinitionProviding.dealerIntentDefinition {
            let content = DealerContentRepresentation(identifier: dealerDefinition.identifier)
            recipient.receive(content)
        }
    }
    
}
