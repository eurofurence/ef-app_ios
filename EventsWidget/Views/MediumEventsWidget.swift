import EventsWidgetLogic
import SwiftUI

struct MediumEventsWidget: View {
    
    var entry: EventTimelineEntry
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading) {
                LargeCalendarIcon()
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityLabel(entry.accessibleSummary)
                
                Spacer()
                
                VStack(alignment: .leading) {
                    EntryEventsCountView(entry: entry)
                    CategoryTextHeadline(category: entry.context.category)
                }
                
            }
            
            VStack(alignment: .leading) {
                switch entry.content {
                case .empty:
                    Spacer()
                    
                    HStack {
                        NoEventsPlaceholderText()
                        Spacer()
                    }
                    
                    Spacer()
                    
                case .events(let events):
                    ForEach(events) { (event) in
                        Link(destination: event.widgetURL) {
                            VStack(alignment: .leading) {
                                HStack {
                                    EventTitle(event)
                                    Spacer()
                                    EventStartTime(event.formattedStartTime)
                                }
                                .accessibilityHidden(true)
                                
                                Text(event.location)
                                    .font(.caption)
                                    .foregroundColor(Color.widgetContentForegroundSecondary)
                                    .lineLimit(1)
                                    .accessibilityHidden(true)
                            }
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(event.accessibilitySummary)
                        }
                        .padding(.trailing)
                        
                        if event != events.last {
                            Divider()
                        }
                    }
                }
            }
        }
        .padding(.top)
    }
    
}
