import EurofurenceIntentDefinitions
import EurofurenceModel

@available(iOS 12.0, *)
extension ViewEventIntent {
    
    convenience init(intentDefinition: ViewEventIntentDefinition) {
        self.init()
        
        eventIdentifier = intentDefinition.identifier.rawValue
        eventName = intentDefinition.eventName
    }
    
}

@available(iOS 12.0, *)
extension ViewEventIntent: EventIntentDefinitionProviding {
    
    var eventIntentDefinition: ViewEventIntentDefinition? {
        guard let identifier = eventIdentifier, let name = eventName else { return nil }
        return ViewEventIntentDefinition(identifier: EventIdentifier(identifier), eventName: name)
    }
    
}
