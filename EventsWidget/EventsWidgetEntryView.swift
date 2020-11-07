import SwiftUI
import WidgetKit

struct EventsWidgetEntryView: View {
    
    var entry: EventsTimelineEntry

    var body: some View {
        Text(entry.date, style: .time)
    }
    
}

struct EventsWidget_Previews: PreviewProvider {
    
    static var previews: some View {
        let entry = EventsTimelineEntry(date: Date())
        
        EventsWidgetEntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        EventsWidgetEntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        
        EventsWidgetEntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
    
}
