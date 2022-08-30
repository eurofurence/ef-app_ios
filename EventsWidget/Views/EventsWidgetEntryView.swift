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
            SmallEventsWidget(entry: entry)
                .springboardStyle()
            
        case .systemMedium:
            MediumEventsWidget(entry: entry)
                .springboardStyle()
            
        default:
            fatalError("Unsupported widget family (\(family))")
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
                accessibilitySummary: "Accessibility Summary"
            ),
            
            EventViewModel(
                id: UUID().uuidString,
                title: "Dealer's Den",
                location: "Dealer's Den - Convention Center Foyer 3",
                formattedStartTime: "13:30",
                accessibilitySummary: "Accessibility Summary"
            ),
            
            EventViewModel(
                id: UUID().uuidString,
                title: "Funny Animals and Amerimanga in Sonic the Hedgehog Archie Series",
                location: "Nizza",
                formattedStartTime: "17:30",
                accessibilitySummary: "Accessibility Summary"
            ),
            
            EventViewModel(
                id: UUID().uuidString,
                title: "Fursuit Photoshoot Registration",
                location: "Fursuit Photoshoot Registration - Estrel Hall B",
                formattedStartTime: "19:00",
                accessibilitySummary: "Accessibility Summary"
            ),
            
            EventViewModel(
                id: UUID().uuidString,
                title: "International Snack Exchange",
                location: "ECC Room 3",
                formattedStartTime: "22:00",
                accessibilitySummary: "Accessibility Summary"
            )
        ]
        
        let smallEntry = EventTimelineEntry(
            date: Date(),
            accessibleSummary: "2 upcoming events",
            content: .events(viewModels: Array(events.prefix(2))),
            context: EventTimelineEntry.Context(category: .upcoming, isFavouritesOnly: false)
        )
        
        let mediumEntry = EventTimelineEntry(
            date: Date(),
            accessibleSummary: "3 upcoming events",
            content: .events(viewModels: Array(events.prefix(3))),
            context: EventTimelineEntry.Context(category: .upcoming, isFavouritesOnly: false)
        )
        
        let noEvents = EventTimelineEntry(
            date: Date(),
            accessibleSummary: "no upcoming events",
            content: .events(viewModels: []),
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
        }
        .environment(\.colorScheme, .dark)
    }
    
}
