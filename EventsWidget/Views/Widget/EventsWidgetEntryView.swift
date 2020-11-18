import EurofurenceIntentDefinitions
import EventsWidgetLogic
import SwiftUI
import WidgetKit

struct EventsWidgetEntryView: View {
    
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

    private struct SmallWidgetContents: View {
        
        var entry: EventTimelineEntry
        
        var body: some View {
            if entry.events.isEmpty {
                VerticalPlaceholderWithPrompt(category: entry.eventCategory, textSize: .small)
            } else {
                WidgetLayout {
                    CategoryTextHeadline(category: entry.eventCategory)
                } content: {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(entry.events) { (event) in
                            VStack(alignment: .leading) {
                                HStack {
                                    EventTitle(event.title)
                                    Spacer()
                                    EventStartTime(event.formattedStartTime)
                                }
                                
                                EventLocation(event.location)
                            }
                        }
                        
                        AdditionalEventsFooter(additionalEventsCount: entry.additionalEventsCount)
                    }
                }
            }
        }
        
    }

    private struct MediumWidgetContents: View {
        
        var entry: EventTimelineEntry
        
        var body: some View {
            if entry.events.isEmpty {
                HorizontalPlaceholderWithPrompt(filter: entry.eventCategory)
            } else {
                WidgetLayout {
                    CategoryTextHeadline(category: entry.eventCategory)
                } content: {
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(entry.events) { (event) in
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
                        
                        AdditionalEventsFooter(additionalEventsCount: entry.additionalEventsCount)
                    }
                }
            }
        }
        
    }

    private struct LargeWidgetContents: View {
        
        @ScaledMetric private var interRowSpacing: CGFloat = 7
        var entry: EventTimelineEntry
        
        var body: some View {
            if entry.events.isEmpty {
                VerticalPlaceholderWithPrompt(category: entry.eventCategory, textSize: .large)
            } else {
                WidgetLayout {
                    CategoryTextHeadline(category: entry.eventCategory)
                } content: {
                    VStack(alignment: .leading) {
                        ForEach(entry.events) { (event) in
                            Link(destination: event.widgetURL) {
                                if event == entry.events.first {
                                    Divider()
                                        .hidden()
                                } else {
                                    Divider()
                                        .padding([.top, .bottom], interRowSpacing)
                                }
                                
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
                        
                        if entry.additionalEventsCount > 0 {
                            Divider()
                                .padding([.top, .bottom], interRowSpacing)
                            
                            AdditionalEventsFooter(additionalEventsCount: entry.additionalEventsCount)
                        }
                    }
                }
            }
        }
    }

    private struct VerticalPlaceholderWithPrompt: View {
        
        var category: EventCategory
        var textSize: CategoryPlaceholderText.Size
        
        var body: some View {
            WidgetColoredBackground {
                VStack {
                    Spacer()
                    
                    NoContentPlaceholderImage()
                        .frame(maxHeight: 250)
                    
                    CategoryPlaceholderText(category: category, size: textSize)
                    
                    Spacer()
                }
            }
        }
        
    }
    
    private struct HorizontalPlaceholderWithPrompt: View {
        
        var filter: EventCategory
        
        var body: some View {
            WidgetColoredBackground {
                HStack(spacing: 17) {
                    Spacer()
                    
                    NoContentPlaceholderImage()
                        .frame(maxHeight: 250)
                        .padding()
                    
                    Spacer()
                    
                    CategoryPlaceholderText(category: filter, size: .large)
                    
                    Spacer()
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
            )
        ]
        
        let smallEntry = EventTimelineEntry(
            date: Date(),
            eventCategory: .upcoming,
            events: Array(events.prefix(2)),
            additionalEventsCount: 7
        )
        
        let mediumEntry = EventTimelineEntry(
            date: Date(),
            eventCategory: .upcoming,
            events: Array(events.prefix(3)),
            additionalEventsCount: 6
        )
        
        let largeEntry = EventTimelineEntry(
            date: Date(),
            eventCategory: .upcoming,
            events: events,
            additionalEventsCount: 4
        )
        
        let noEvents = EventTimelineEntry(
            date: Date(),
            eventCategory: .upcoming,
            events: [],
            additionalEventsCount: 0
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
