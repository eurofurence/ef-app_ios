import EurofurenceIntentDefinitions
import EurofurenceModel

struct IntentDefinitionProvidingFactory {
    
    static func intentDefinitionProvider(from intent: Any?) -> Any? {
        guard #available(iOS 12.0, *) else { return nil }
        
        var intentDefinitionProvider: Any?
        if let viewEventIntent = intent as? ViewEventIntent {
            intentDefinitionProvider = EventIntentWrapper(intent: viewEventIntent)
        }
        
        return intentDefinitionProvider
    }
    
    @available(iOS 12.0, *)
    private struct EventIntentWrapper: EventIntentDefinitionProviding {
        
        var eventIntentDefinition: ViewEventIntentDefinition?
        
        init?(intent: ViewEventIntent) {
            guard let identifier = intent.identifier, let name = intent.eventName else { return nil }
            eventIntentDefinition = ViewEventIntentDefinition(identifier: EventIdentifier(identifier), eventName: name)
        }
        
    }
    
}
