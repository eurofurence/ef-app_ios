import EurofurenceIntentDefinitions
import EventsWidgetLogic
import SwiftUI
import WidgetKit

struct EventsWidgetEntryView: View {
    
    @Environment(\.widgetFamily) private var family: WidgetFamily
    
    var entry: EventTimelineEntry

    var body: some View {
        WidgetLayout {
            WidgetTitle(entry: entry)
        } content: {
            switch entry.content {
            case .events(let events, let additionalEventCount):
                if events.isEmpty {
                    PlaceholderPrompt(category: entry.context.category)
                } else {
                    switch family {
                    case .systemSmall:
                        SmallWidgetContents(events: events, additionalEventsCount: additionalEventCount)
                        
                    case .systemMedium:
                        MediumWidgetContents(events: events, additionalEventsCount: additionalEventCount)
                        
                    case .systemLarge:
                        LargeWidgetContents(events: events, additionalEventsCount: additionalEventCount)
                        
                    @unknown default:
                        MediumWidgetContents(events: events, additionalEventsCount: additionalEventCount)
                    }
                }
            }
            
        }
    }
    
    private struct WidgetTitle: View {
        
        var entry: EventTimelineEntry
        
        var body: some View {
            HStack {
                CategoryTextHeadline(category: entry.context.category)
                
                if entry.context.isFavouritesOnly {
                    Spacer()
                    
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .padding(.trailing)
                }
            }
        }
        
    }

    private struct SmallWidgetContents: View {
        
        var events: [EventViewModel]
        var additionalEventsCount: Int
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(events) { (event) in
                    VStack(alignment: .leading) {
                        HStack {
                            EventTitle(event.title)
                            Spacer()
                            EventStartTime(event.formattedStartTime)
                        }
                        
                        EventLocation(event.location)
                    }
                }
                
                AdditionalEventsFooter(additionalEventsCount: additionalEventsCount)
            }
        }
        
    }
    
    private struct MediumWidgetContents: View {
        
        var events: [EventViewModel]
        var additionalEventsCount: Int
        
        var body: some View {
            VStack(alignment: .leading, spacing: 3) {
                ForEach(events) { (event) in
                    Link(destination: event.widgetURL) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                EventTitle(event.title)
                                EventLocation(event.location)
                            }
                            
                            Spacer()
                            
                            HStack {
                                EventStartTime(event.formattedStartTime)
                                EventEndTime(event.formattedEndTime)
                            }
                        }
                    }
                }
                
                AdditionalEventsFooter(additionalEventsCount: additionalEventsCount)
            }
        }
        
    }

    private struct LargeWidgetContents: View {
        
        var events: [EventViewModel]
        var additionalEventsCount: Int
        
        var body: some View {
            VStack(alignment: .leading, spacing: 18) {
                ForEach(events) { (event) in
                    Link(destination: event.widgetURL) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                EventTitle(event.title)
                                EventLocation(event.location)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                EventStartTime(event.formattedStartTime)
                                EventEndTime(event.formattedEndTime)
                            }
                        }
                    }
                }
                
                if additionalEventsCount > 0 {
                    AdditionalEventsFooter(additionalEventsCount: additionalEventsCount)
                }
            }
        }
    }
    
    private struct PlaceholderPrompt: View {
        
        var category: EventCategory
        
        var body: some View {
            VStack {
                Spacer()
                
                CategoryPlaceholderText(category: category)
                    .padding()
                
                Spacer()
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
            )
        ]
        
        let smallEntry = EventTimelineEntry(
            date: Date(),
            content: .events(viewModels: Array(events.prefix(2)), additionalEventsCount: 7),
            context: EventTimelineEntry.Context(category: .upcoming, isFavouritesOnly: false)
        )
        
        let mediumEntry = EventTimelineEntry(
            date: Date(),
            content: .events(viewModels: Array(events.prefix(3)), additionalEventsCount: 6),
            context: EventTimelineEntry.Context(category: .upcoming, isFavouritesOnly: false)
        )
        
        let largeEntry = EventTimelineEntry(
            date: Date(),
            content: .events(viewModels: events, additionalEventsCount: 4),
            context: EventTimelineEntry.Context(category: .upcoming, isFavouritesOnly: false)
        )
        
        let noEvents = EventTimelineEntry(
            date: Date(),
            content: .events(viewModels: [], additionalEventsCount: 0),
            context: EventTimelineEntry.Context(category: .upcoming, isFavouritesOnly: false)
        )
        
        Group {
            EventsWidgetEntryView(entry: smallEntry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            EventsWidgetEntryView(entry: noEvents)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            EventsWidgetEntryView(entry: mediumEntry)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            EventsWidgetEntryView(entry: noEvents)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            EventsWidgetEntryView(entry: largeEntry)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
            
            EventsWidgetEntryView(entry: noEvents)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
        .previewDisplayName("Light")
        .environment(\.colorScheme, .light)
        
        Group {
            EventsWidgetEntryView(entry: smallEntry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            EventsWidgetEntryView(entry: noEvents)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            EventsWidgetEntryView(entry: mediumEntry)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            EventsWidgetEntryView(entry: noEvents)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            EventsWidgetEntryView(entry: largeEntry)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
            
            EventsWidgetEntryView(entry: noEvents)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
        .environment(\.colorScheme, .dark)
    }
    
}
