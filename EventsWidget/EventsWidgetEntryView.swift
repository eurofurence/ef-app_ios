import SwiftUI
import WidgetKit

struct EventsWidgetEntryView: View {
    
    var entry: EventsTimelineEntry

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
            if entry.events.isEmpty {
                PlaceholderView(filter: entry.filter)
            } else {
                VerticalEventsCollectionView(
                    filter: entry.filter,
                    events: entry.events,
                    maximumNumberOfEvents: 4
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
                
            case .favourites:
                Text("No upcoming favourites")
                
            case .running:
                Text("No running events")
                
            case .unknown:
                Text("")
            }
        }
        
    }
    
    private struct VerticalEventsCollectionView: View {
        
        var filter: EventFilter
        var events: EventsCollection
        var maximumNumberOfEvents: Int
        
        var body: some View {
            VStack(alignment: .leading) {
                FilterTextHeadline(filter: filter)
                
                Divider()
                    .padding([.bottom])
                
                VStack(alignment: .leading, spacing: 24) {
                    EventsList(events: events.take(maximum: maximumNumberOfEvents))
                }
                
                if let remaining = events.remaining(afterTaking: maximumNumberOfEvents) {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Text(verbatim: .additionalEventsFooter(remaining: remaining))
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
                    Text(event.eventTitle)
                        .font(.footnote)
                    
                    Text(event.eventLocation)
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
            ),
            
            EventViewModel(
                formattedStartTime: "19:00",
                formattedEndTime: "20:30",
                eventTitle: "Fursuit Photoshoot Registration",
                eventLocation: "Fursuit Photoshoot Registration - Estrel Hall B"
            ),
            
            EventViewModel(
                formattedStartTime: "22:00",
                formattedEndTime: "00:30",
                eventTitle: "International Snack Exchange",
                eventLocation: "ECC Room 3"
            ),
            
            EventViewModel(
                formattedStartTime: "23:00",
                formattedEndTime: "03:00",
                eventTitle: "Games Corner",
                eventLocation: "Estrel Hall A"
            )
        ]
        
        let manyEvents = EventsTimelineEntry(
            date: Date(),
            filter: .upcoming,
            events: EventsCollection(viewModels: events)
        )
        
        let noEvents = EventsTimelineEntry(
            date: Date(),
            filter: .upcoming,
            events: EventsCollection(viewModels: [])
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
