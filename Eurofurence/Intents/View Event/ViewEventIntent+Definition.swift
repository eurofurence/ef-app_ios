import EurofurenceIntentDefinitions
import EurofurenceModel
import EventDetailComponent

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
    
    public var eventIntentDefinition: ViewEventIntentDefinition? {
        guard let identifier = eventIdentifier, let name = eventName else { return nil }
        return ViewEventIntentDefinition(identifier: EventIdentifier(identifier), eventName: name)
    }
    
}
