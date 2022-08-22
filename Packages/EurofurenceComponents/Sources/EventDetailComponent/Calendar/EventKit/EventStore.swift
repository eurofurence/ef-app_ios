public protocol EventStore {
    
    func editEvent(definition event: EventStoreEventDefinition, sender: Any?)
    func removeEvent(identifiedBy identifier: String)
    
}
