import WidgetKit
import SwiftUI
import Intents

@main
struct EventsWidget: Widget {
    let kind: String = "EventsWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: EventsTimelineProvider()) { entry in
            EventsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
