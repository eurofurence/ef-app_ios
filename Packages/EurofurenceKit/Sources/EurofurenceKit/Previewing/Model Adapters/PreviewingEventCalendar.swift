class PreviewingEventCalendar: EventCalendar {
    
    let calendarChanged = EventCalendarChangedPublisher()
    
    func contains(entry: EventCalendarEntry) -> Bool {
        false
    }
    
}
