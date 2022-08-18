import Foundation.NSUUID

class EventSubscription: CustomStringConvertible, Equatable, Hashable {
    
    private let id: AnyHashable
    private unowned let eventBus: EventBus
    private let _handle: (Any) -> Void
    private let _description: () -> String
    
    var description: String {
        _description()
    }
    
    static func == (lhs: EventSubscription, rhs: EventSubscription) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init<Consumer>(dispatcher: Consumer, eventBus: EventBus) where Consumer: EventConsumer {
        self.id = UUID()
        self.eventBus = eventBus
        
        _handle = { (event) in
            if let event = event as? Consumer.Event {
                dispatcher.consume(event: event)
            }
        }
        
        _description = {
            dispatcher.description
        }
    }
    
    @inline(__always)
    func handle(event: Any) {
        _handle(event)
    }
    
    deinit {
        eventBus.cancel(subscription: self)
    }
    
}
