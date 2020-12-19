import EurofurenceIntentDefinitions
import Intents
import SwiftUI
import WidgetKit

@main
struct EventsWidget: Widget {
    
    let kind = "org.eurofurence.EventsWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: ViewEventsIntent.self,
            provider: EventsTimelineProvider(),
            content: EventsWidgetEntryView.init
        )
        .configurationDisplayName("EventsWidgetDisplayName")
        .description("EventsWidgetDescription")
    }
    
}
