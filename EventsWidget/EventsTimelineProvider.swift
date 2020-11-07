import WidgetKit

struct EventsTimelineProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> EventsTimelineEntry {
        EventsTimelineEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(
        for configuration: ConfigurationIntent,
        in context: Context,
        completion: @escaping (EventsTimelineEntry) -> ()
    ) {
        let entry = EventsTimelineEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(
        for configuration: ConfigurationIntent,
        in context: Context,
        completion: @escaping (Timeline<EventsTimelineEntry>) -> ()
    ) {
        var entries: [EventsTimelineEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = EventsTimelineEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
}
