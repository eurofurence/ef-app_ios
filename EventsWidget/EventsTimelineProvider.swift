import WidgetKit

struct EventsTimelineProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> EventsTimelineEntry {
        EventsTimelineEntry(date: Date(), events: [])
    }

    func getSnapshot(
        for configuration: ViewEventsIntent,
        in context: Context,
        completion: @escaping (EventsTimelineEntry) -> ()
    ) {
        let entry = EventsTimelineEntry(date: Date(), events: [])
        completion(entry)
    }

    func getTimeline(
        for configuration: ViewEventsIntent,
        in context: Context,
        completion: @escaping (Timeline<EventsTimelineEntry>) -> ()
    ) {
        var entries: [EventsTimelineEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = EventsTimelineEntry(date: entryDate, events: [])
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
}
