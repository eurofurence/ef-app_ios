import EventDetailComponent

public struct StubEventIntentDefinitionProviding: Hashable, EventIntentDefinitionProviding {
    
    public var eventIntentDefinition: ViewEventIntentDefinition?
    
    public init(eventIntentDefinition: ViewEventIntentDefinition? = nil) {
        self.eventIntentDefinition = eventIntentDefinition
    }
    
}
