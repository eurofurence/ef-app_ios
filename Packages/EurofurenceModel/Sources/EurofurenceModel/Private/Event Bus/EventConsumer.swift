/**
 An `EventConsumer` represents a type that consumes events transmitted through
 an `EventBus`, acting upon the meaning and representation of the received
 `Event`. `Event`s could represent a change in state, timer event, action etc.
 */
public protocol EventConsumer: CustomStringConvertible {

    /// Represents the type of the event this consumer will observe.
    associatedtype Event

    /**
     Tells this consumer to accept and act upon the `Event`.
     
     - parameters:
        - event: An `Event` broadcast through an `EventBus`, representing a
                 change in state, action or other behaviour within your program.
    */
    func consume(event: Event)

}

extension EventConsumer {
    
    public var description: String {
        String(describing: type(of: self))
    }
    
}
