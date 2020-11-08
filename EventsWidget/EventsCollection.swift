struct EventsCollection {
    
    private var viewModels: [EventViewModel]
    
    init(viewModels: [EventViewModel]) {
        self.viewModels = viewModels
    }
    
    func take(maximum: Int) -> [EventViewModel] {
        Array(viewModels.prefix(maximum))
    }
    
}
