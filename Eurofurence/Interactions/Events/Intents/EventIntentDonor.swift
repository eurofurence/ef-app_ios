import EurofurenceModel
import Foundation

struct ViewEventIntentDefinition: Equatable {
    
    var identifier: EventIdentifier
    var eventName: String
    
}

protocol EventIntentDonor {
    
    func donateEventIntent(definition: ViewEventIntentDefinition)
    
}
