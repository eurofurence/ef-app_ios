import SwiftUI
import WidgetKit

struct EventsWidgetEntryView : View {
    
    var entry: EventsTimelineProvider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
    
}

struct EventsWidget_Previews: PreviewProvider {
    
    static var previews: some View {
        EventsWidgetEntryView(entry: EventsTimelineEntry(date: Date(), configuration: ViewEventsIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
    
}
