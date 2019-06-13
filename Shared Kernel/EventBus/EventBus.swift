import Foundation

/// An `EventBus` provides a mechanism for broadcasting events and relevant
/// information throughout your application, mediating the transmission from
/// broadcaster to receiver.
public class EventBus {

    /// Specifies the manner in which an `EventBus` should re-deliver previously
    /// posted events when new `EventConsumer`s subscribe to the bus.
    public enum DeliveryMode {

        /// Past events should not be re-delivered to new consumers.
        case simple

        /// The most recent copy of the event should be delivered to the
        /// consumer.
        case replayLast

    }

    // MARK: Properties

    private var storage = [EventBusRegistration]()
    private let cache = EventCache()

    /// Specifies the `DeliveryMode` of events for new subscribers. The default
    /// behaviour is to not re-deliver events.
    public var redeliveryMode: DeliveryMode = .simple

    // MARK: Initialization

    /// Initializes a new `EventBus` instance.
    public init() { }

    // MARK: Public

    /**
     Appends an `EventConsumer` to this `EventBus`, allowing for propagation of 
     future events towards the consumer.
     
     If the `redeliveryMode` of this `EventBus` is set to `ReplayLast`, and a
     compatible event has been previously broadcast, the consumer will
     immediately consume the event before this function returns.
     
     - parameters:
        - consumer: An `EventConsumer` to be subscribed for events posted within
                    this `EventBus`
    */
    public func subscribe<Consumer: EventConsumer>(consumer: Consumer) {
        storage.append(EventConsumerRegistration(consumer: consumer))

        guard case .replayLast = redeliveryMode,
              let event = cache.cachedEvent(ofType: Consumer.Event.self) else {
                return
        }

        consumer.consume(event: event)
    }

    /**
     Removes an `EventConsumer` from this `EventBus`, preventing any future
     events reaching the consumer until it is re-subscribed.
     
     - parameters:
        - consumer: An `EventConsumer` to be unsubscribed from this `EventBus`
    */
    public func unsubscribe<Consumer: EventConsumer>(consumer: Consumer) {
        guard let index = storage.firstIndex(where: { $0.represents(consumer: consumer) }) else {
            return
        }

        storage.remove(at: index)
    }

    /**
     Posts an event through this `EventBus`, notifying any relevant
     `EventConsumer`s.
     
     The `EventBus` will retain events it posts for re-delivery later if
     the `redeliveryMode` is set to `ReplayLast`. Replaying the same event
     again will replace the old value.
     
     - parameters:
        - event: The event to be broadcast through this `EventBus`. For
                 reference types that conform to the `NSCopying` protocol, each 
                 consumer will consume unique copies of the event.
    */
    public func post(_ event: Any) {
        storage.filter({ $0.supports(event) }).forEach { (registration) in
            var dispatchable = event
            if let copyable = event as? NSCopying {
                dispatchable = copyable.copy(with: nil)
            }

            registration.handle(event: dispatchable)
        }

        cache.append(event: event)
    }

}
