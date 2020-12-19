public protocol EventRepository {
    
    func loadEvents(completionHandler: @escaping ([Event]) -> Void)
    
}
