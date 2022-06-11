import EventsWidgetLogic
import SwiftUI

struct SmallEventsWidget: View {
    
    var entry: EventTimelineEntry
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                LargeCalendarIcon()
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityLabel(entry.accessibleSummary)
                
                Spacer()
                EntryEventsCountView(entry: entry)
            }
            
            Spacer()
            
            CategoryTextHeadline(category: entry.context.category)
            
            switch entry.content {
            case .empty:
                NoEventsPlaceholderText()
                    .font(.caption)
                
            case .events(let events):
                ForEach(events) { (event) in
                    VStack(alignment: .leading) {
                        HStack {
                            EventTitle(event)
                            Spacer()
                            EventStartTime(event.formattedStartTime)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel(event.accessibilitySummary)
                    }
                    
                    if event != events.last {
                        Divider()
                    }
                }
            }
        }
        .padding(.trailing)
        .padding(.top, 16)
    }
    
}
