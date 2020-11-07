import SwiftUI
import WidgetKit

struct EventsWidgetEntryView: View {
    
    var entry: EventsTimelineEntry

    var body: some View {
        ZStack {
            Color.widgetBackground
            WidgetContents(entry: entry)
                .foregroundColor(.white)
        }
    }
    
}

private struct WidgetContents: View {
    
    @Environment(\.widgetFamily) private var family: WidgetFamily
    
    var entry: EventsTimelineEntry
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetContents(entry: entry)
            
        case .systemMedium:
            MediumWidgetContents(entry: entry)
            
        case .systemLarge:
            LargeWidgetContents(entry: entry)
            
        @unknown default:
            MediumWidgetContents(entry: entry)
        }
    }
    
}

private struct SmallWidgetContents: View {
    
    var entry: EventsTimelineEntry
    
    var body: some View {
        Text("Small")
    }
    
}

private struct MediumWidgetContents: View {
    
    var entry: EventsTimelineEntry
    
    var body: some View {
        Text("Medium")
    }
    
}

private struct LargeWidgetContents: View {
    
    var entry: EventsTimelineEntry
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(entry.events) { (event) in
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(event.formattedStartTime)
                                .font(.callout)
                            Spacer()
                        }
                        
                        Text(event.formattedEndTime)
                            .font(.callout)
                            .foregroundColor(.secondaryText)
                            .alignmentGuide(.leading) { h in -18 }
                    }
                    .frame(minWidth: 100, idealWidth: 100, maxWidth: 100)
                    
                    VStack(alignment: .leading) {
                        Text(event.eventTitle)
                            .font(.callout)
                        
                        Text(event.eventLocation)
                            .font(.callout)
                            .lineLimit(3)
                            .foregroundColor(.secondaryText)
                    }
                }
                .padding()
            }
        }
    }
    
}

struct EventsWidget_Previews: PreviewProvider {
    
    static var previews: some View {
        let events: [EventViewModel] = [
            EventViewModel(
                formattedStartTime: "13:00",
                formattedEndTime: "14:30",
                eventTitle: "Trans Meet-Up",
                eventLocation: "Nizza"
            ),
            
            EventViewModel(
                formattedStartTime: "13:30",
                formattedEndTime: "15:00",
                eventTitle: "Dealer's Den",
                eventLocation: "Dealer's Den - Convention Center Foyer 3"
            ),
            
            EventViewModel(
                formattedStartTime: "17:30",
                formattedEndTime: "18:30",
                eventTitle: "Funny Animals and Amerimanga in Sonic the Hedgehog Archie Series",
                eventLocation: "Nizza"
            )
        ]
        
        let entry = EventsTimelineEntry(date: Date(), events: events)
        
        Group {
            EventsWidgetEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            EventsWidgetEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            EventsWidgetEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
        .environment(\.colorScheme, .light)
        
        Group {
            EventsWidgetEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            EventsWidgetEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            EventsWidgetEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
        .environment(\.colorScheme, .dark)
    }
    
}
