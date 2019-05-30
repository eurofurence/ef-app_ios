import EurofurenceModel
import Intents

struct ConcreteEventIntentDonor: EventIntentDonor {
    
    func donateEventIntent(definition: ViewEventIntentDefinition) {
        guard #available(iOS 12.0, *) else { return }
        
        let intent = ViewEventIntent()
        intent.eventIdentifier = definition.identifier.rawValue
        intent.eventName = definition.eventName
        
        let interation = INInteraction(intent: intent, response: nil)
        interation.identifier = definition.identifier.rawValue
        
        interation.donate { (error) in
            if let error = error {
                print("Error donating interaction: \(error)")
            }
        }
    }
    
}
