import Foundation

struct DataStoreChangedConsumer: EventConsumer {

    let handler: () -> Void

    typealias Event = DomainEvent.DataStoreChangedEvent

    func consume(event: DomainEvent.DataStoreChangedEvent) {
        handler()
    }

}
