struct EventsCollection {
    
    private var viewModels: [EventViewModel]
    
    init(viewModels: [EventViewModel]) {
        self.viewModels = viewModels
    }
    
    func take(maximum: Int) -> [EventViewModel] {
        Array(viewModels.prefix(maximum))
    }
    
    func remaining(afterTaking maximum: Int) -> Int? {
        let remainder = viewModels.count - maximum
        return remainder < 0 ? nil : remainder
    }
    
}
