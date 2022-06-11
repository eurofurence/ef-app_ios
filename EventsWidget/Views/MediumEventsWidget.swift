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
                                
                                Text(event.location)
                                    .font(.caption)
                                    .foregroundColor(Color.widgetContentForegroundSecondary)
                                    .lineLimit(1)
                            }
                            .accessibilityElement(children: .combine)
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
