import SwiftUI
import WidgetKit

struct EventsWidgetEntryView: View {
    
    var entry: EventsTimelineEntry

    var body: some View {
        ZStack(alignment: .top) {
            Color.widgetBackground
            WidgetContents(entry: entry)
                .foregroundColor(.white)
                .padding()
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

private extension HorizontalAlignment {
    
    private enum FilterTitleAlignmentID: AlignmentID {
        
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.leading]
        }
        
    }
    
    static let filterTitle = HorizontalAlignment(FilterTitleAlignmentID.self)
    
}

private struct LargeWidgetContents: View {
    
    var entry: EventsTimelineEntry
    
    var body: some View {
        VStack(alignment: .filterTitle) {
            EventFilterText(filter: entry.filter)
                .alignmentGuide(.filterTitle) { d in d[.leading] }
                .padding([.bottom])
            
            VStack(alignment: .leading, spacing: 14) {
                let events: [EventViewModel] = entry.events
                EventsList(events: events)
            }
        }
    }
    
}

private struct EventsList: View {
    
    var events: [EventViewModel]
    
    var body: some View {
        ForEach(events) { (event) in
            EventRow(event: event)
            
            if event.id != events.last?.id {
                Divider()
                    .padding([.leading, .trailing])
            }
        }
    }
    
}

private struct EventRow: View {
    
    var event: EventViewModel
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack {
                    Text(event.formattedStartTime)
                        .font(.callout)
                        .alignmentGuide(.filterTitle) { d in d[.leading] }
                    
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
        
        let entry = EventsTimelineEntry(
            date: Date(),
            filter: .upcoming,
            events: events
        )
        
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
