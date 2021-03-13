import EurofurenceApplication

class CapturingEventIntentDonor: EventIntentDonor {
    
    private(set) var donatedEventIntentDefinition: ViewEventIntentDefinition?
    func donateEventIntent(definition: ViewEventIntentDefinition) {
        donatedEventIntentDefinition = definition
    }
    
}
