struct EventViewModelFactory {
    
    let eventTimeFormatter: EventTimeFormatter
    let accessibilityFormatter: EventTimeFormatter
    
    func makeViewModel(for event: Event) -> EventViewModel {
        EventViewModel(
            event: event,
            eventTimeFormatter: eventTimeFormatter,
            accessibilityFormatter: accessibilityFormatter
        )
    }
    
}
