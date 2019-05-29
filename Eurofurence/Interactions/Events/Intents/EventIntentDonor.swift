import EurofurenceModel
import Foundation

struct EventIntentTraits: Equatable {
    
    var identifier: EventIdentifier
    var eventName: String
    
}

protocol EventIntentDonor {
    
    func donateEventIntent(traits: EventIntentTraits)
    
}
