import EventsWidgetLogic
import SwiftUI
import WidgetKit

struct EventsWidgetEntryView: View {
    
    var entry: EventTimelineEntry

    var body: some View {
        ZStack(alignment: .top) {
            Color.widgetBackground
            WidgetContents(entry: entry)
                .foregroundColor(.white)
                .padding(20)
        }
    }
    
    private struct WidgetContents: View {
        
        @Environment(\.widgetFamily) private var family: WidgetFamily
        
        var entry: EventTimelineEntry
        
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
        
        var entry: EventTimelineEntry
        
        var body: some View {
            Text("Small")
        }
        
    }

    private struct MediumWidgetContents: View {
        
        var entry: EventTimelineEntry
        
        var body: some View {
            Text("Medium")
        }
        
    }

    private struct LargeWidgetContents: View {
        
        var entry: EventTimelineEntry
        
        var body: some View {
            if entry.events.isEmpty {
                PlaceholderView(filter: .upcoming)
            } else {
                VerticalEventsCollectionView(
                    filter: .upcoming,
                    events: entry.events,
                    remainingEvents: 4
                )
            }
        }
    }

    private struct PlaceholderView: View {
        
        var filter: EventFilter
        
        var body: some View {
            VStack(spacing: 17) {
                Spacer()
                
                Image("No Content Placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 250)
                    .foregroundColor(.secondaryText)
                
                FilterPlaceholderText(filter: filter)
                
                Spacer()
            }
        }
        
    }
    
    private struct FilterPlaceholderText: View {
        
        var filter: EventFilter
        
        var body: some View {
            text
                .font(.footnote)
                .foregroundColor(.secondaryText)
        }
        
        @ViewBuilder
        private var text: some View {
            switch filter {
            case .upcoming:
                Text("No upcoming events")
                
            case .running:
                Text("No running events")
                
            case .unknown:
                Text("")
            }
        }
        
    }
    
    private struct VerticalEventsCollectionView: View {
        
        var filter: EventFilter
        var events: [EventViewModel]
        var remainingEvents: Int
        
        var body: some View {
            VStack(alignment: .leading) {
                FilterTextHeadline(filter: filter)
                
                Divider()
                    .padding([.bottom])
                
                VStack(alignment: .leading, spacing: 24) {
                    EventsList(events: events)
                }
                
                if remainingEvents > 0 {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Text(verbatim: .additionalEventsFooter(remaining: remainingEvents))
                            .font(.footnote)
                    }
                }
            }
        }
        
    }

    private struct EventsList: View {
        
        var events: [EventViewModel]
        
        var body: some View {
            ForEach(events) { (event) in
                EventRow(event: event)
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
                            .font(.footnote)
                        
                        Spacer()
                    }
                    
                    Text(event.formattedEndTime)
                        .font(.footnote)
                        .foregroundColor(.secondaryText)
                        .alignmentGuide(.leading) { h in -18 }
                }
                .frame(minWidth: 100, idealWidth: 100, maxWidth: 100)
                
                VStack(alignment: .leading) {
                    Text(event.title)
                        .font(.footnote)
                    
                    Text(event.location)
                        .font(.footnote)
                        .lineLimit(3)
                        .foregroundColor(.secondaryText)
                }
            }
        }
        
    }
    
}

struct EventsWidget_Previews: PreviewProvider {
    
    static var previews: some View {
        let events: [EventViewModel] = [
            EventViewModel(
                id: UUID().uuidString,
                title: "Trans Meet-Up",
                location: "Nizza",
                formattedStartTime: "13:00",
                formattedEndTime: "14:30"
            ),
            
            EventViewModel(
                id: UUID().uuidString,
                title: "Dealer's Den",
                location: "Dealer's Den - Convention Center Foyer 3",
                formattedStartTime: "13:30",
                formattedEndTime: "15:00"
            ),
            
            EventViewModel(
                id: UUID().uuidString,
                title: "Funny Animals and Amerimanga in Sonic the Hedgehog Archie Series",
                location: "Nizza",
                formattedStartTime: "17:30",
                formattedEndTime: "18:30"
            ),
            
            EventViewModel(
                id: UUID().uuidString,
                title: "Fursuit Photoshoot Registration",
                location: "Fursuit Photoshoot Registration - Estrel Hall B",
                formattedStartTime: "19:00",
                formattedEndTime: "20:30"
            ),
            
            EventViewModel(
                id: UUID().uuidString,
                title: "International Snack Exchange",
                location: "ECC Room 3",
                formattedStartTime: "22:00",
                formattedEndTime: "00:30"
            ),
            
            EventViewModel(
                id: UUID().uuidString,
                title: "Games Corner",
                location: "Estrel Hall A",
                formattedStartTime: "23:00",
                formattedEndTime: "03:00"
            )
        ]
        
        let manyEvents = EventTimelineEntry(
            date: Date(),
            events: events,
            additionalEventsCount: 3
        )
        
        let noEvents = EventTimelineEntry(
            date: Date(),
            events: [],
            additionalEventsCount: 0
        )
        
        Group {
            EventsWidgetEntryView(entry: manyEvents)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            EventsWidgetEntryView(entry: noEvents)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            EventsWidgetEntryView(entry: manyEvents)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            EventsWidgetEntryView(entry: noEvents)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            EventsWidgetEntryView(entry: manyEvents)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
            
            EventsWidgetEntryView(entry: noEvents)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
        .previewDisplayName("Light")
        .environment(\.colorScheme, .light)
        
        Group {
            EventsWidgetEntryView(entry: manyEvents)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            EventsWidgetEntryView(entry: noEvents)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            EventsWidgetEntryView(entry: manyEvents)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            EventsWidgetEntryView(entry: noEvents)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            EventsWidgetEntryView(entry: manyEvents)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
            
            EventsWidgetEntryView(entry: noEvents)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
        .environment(\.colorScheme, .dark)
    }
    
}
