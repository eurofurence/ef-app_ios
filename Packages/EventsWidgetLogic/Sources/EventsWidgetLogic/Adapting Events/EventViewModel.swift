public struct EventViewModel: Equatable {
    
    public var id: String
    public var title: String
    
    public init(id: String, title: String) {
        self.id = id
        self.title = title
    }
    
    init(event: Event) {
        self.init(id: event.id, title: event.title)
    }
    
}
