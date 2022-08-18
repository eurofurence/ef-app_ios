import Foundation

struct DataStoreChangedConsumer: EventConsumer {

    let description: String
    private let handler: () -> Void
    
    init(_ description: String, handler: @escaping () -> Void) {
        self.description = description
        self.handler = handler
    }

    typealias Event = DomainEvent.DataStoreChangedEvent

    func consume(event: DomainEvent.DataStoreChangedEvent) {
        handler()
    }

}
