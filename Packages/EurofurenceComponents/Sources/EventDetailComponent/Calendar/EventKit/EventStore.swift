import Foundation

public protocol EventStore {
    
    func editEvent(
        definition event: EventStoreEventDefinition,
        sender: Any?,
        completionHandler: @escaping (Bool) -> Void
    )
    
    func removeEvent(identifiedBy eventDefinition: EventStoreEventDefinition)
    
    func contains(eventDefinition: EventStoreEventDefinition) -> Bool
    
}
