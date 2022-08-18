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

    private var subscriptions = WeakCollection<EventSubscription>()
    private let cache = EventCache()

    /// Specifies the `DeliveryMode` of events for new subscribers. The default
    /// behaviour is to not re-deliver events.
    public var redeliveryMode: DeliveryMode = .simple

    // MARK: Initialization

    /// Initializes a new `EventBus` instance.
    public init() { }
    
    public enum DispatchPriority {
        case normal
        case last
    }

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
     
     - Returns:
        A registration of the subscription. The caller must retain this subcription. Once the subscription has been
        deallocated, the consumer will stop being notified.
    */
    public func subscribe<Consumer: EventConsumer>(
        consumer: Consumer,
        priority: DispatchPriority = .normal
    ) -> AnyHashable {
        let subscription = EventSubscription(dispatcher: consumer, eventBus: self)
        subscriptions.add(subscription, preferredOrder: priority == .normal ? .none : .last)

        if case .replayLast = redeliveryMode, let event = cache.cachedEvent(ofType: Consumer.Event.self) {
            consumer.consume(event: event)
        }

        return subscription
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
        subscriptions.forEach { (consumer) in
            var dispatchable = event
            if let copyable = event as? NSCopying {
                dispatchable = copyable.copy(with: nil)
            }

            consumer.handle(event: dispatchable)
        }

        cache.append(event: event)
    }
    
    func cancel(subscription: EventSubscription) {
        subscriptions.remove(subscription)
    }

}
