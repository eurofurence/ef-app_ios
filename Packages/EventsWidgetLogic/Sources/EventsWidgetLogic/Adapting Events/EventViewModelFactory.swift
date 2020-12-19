struct EventViewModelFactory {
    
    let eventTimeFormatter: EventTimeFormatter
    
    func makeViewModel(for event: Event) -> EventViewModel {
        EventViewModel(event: event, eventTimeFormatter: eventTimeFormatter)
    }
    
}
