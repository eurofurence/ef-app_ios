import DealerComponent
import EurofurenceIntentDefinitions
import EurofurenceModel
import Intents

struct DonateFromAppDealerIntentDonor: ViewDealerIntentDonor {
    
    func donate(_ viewDealerIntent: ViewDealerIntentDefinition) {
        guard #available(iOS 12.0, *) else { return }
        
        let intent = ViewDealerIntent(intentDefinition: viewDealerIntent)
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.identifier = viewDealerIntent.identifier.rawValue
        
        interaction.donate { (error) in
            if let error = error {
                print("Error donating interaction: \(error)")
            }
        }
    }
    
}
