@testable import Eurofurence

class CapturingEventIntentDonor: EventIntentDonor {
    
    private(set) var donatedEventIntentTraits: EventIntentTraits?
    func donateEventIntent(traits: EventIntentTraits) {
        donatedEventIntentTraits = traits
    }
    
}
