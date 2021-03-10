final class EventCache {

    // MARK: Properties

    private var storage = [Any]()

    // MARK: Public

    func append(event: Any) {
        if let index = storage.firstIndex(where: { type(of: $0) == type(of: event) }) {
            storage.remove(at: index)
        }

        storage.append(event)
    }

    func cachedEvent<Event>(ofType type: Event.Type) -> Event? {
        return storage.compactMap({ $0 as? Event }).first
    }

}
