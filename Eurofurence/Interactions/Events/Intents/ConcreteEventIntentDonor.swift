import EurofurenceModel
import Intents

struct ConcreteEventIntentDonor: EventIntentDonor {
    
    func donateEventIntent(traits: EventIntentTraits) {
        guard #available(iOS 12.0, *) else { return }
        
        let intent = ViewEventIntent()
        intent.eventIdentifier = traits.identifier.rawValue
        intent.eventName = traits.eventName
        
        let interation = INInteraction(intent: intent, response: nil)
        interation.identifier = traits.identifier.rawValue
        
        interation.donate { (error) in
            if let error = error {
                print("Error donating interaction: \(error)")
            }
        }
    }
    
}
