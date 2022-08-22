import Foundation

public protocol EventStore: AnyObject {
    
    /* weak */ var delegate: EventStoreDelegate? { get set }
    
    func editEvent(definition event: EventStoreEventDefinition, sender: Any?)
    
    func removeEvent(identifiedBy eventDefinition: EventStoreEventDefinition)
    
    func contains(eventDefinition: EventStoreEventDefinition) -> Bool
    
}

public protocol EventStoreDelegate: AnyObject {
    
    func eventStoreChanged(_ eventStore: EventStore)
    
}
