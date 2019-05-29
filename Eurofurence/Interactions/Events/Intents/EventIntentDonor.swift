import EurofurenceModel
import Foundation

struct EventIntentTraits: Equatable {
    
    var identifier: EventIdentifier
    var title: String
    var subtitle: String
    var startTime: Date
    var endTime: Date
    
}

protocol EventIntentDonor {
    
    func donateEventIntent(traits: EventIntentTraits)
    
}
