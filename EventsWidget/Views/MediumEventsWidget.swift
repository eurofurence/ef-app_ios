import EventsWidgetLogic
import SwiftUI

struct MediumEventsWidget: View {
    
    var entry: EventTimelineEntry
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                LargeCalendarIcon()
                
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
                    
                    NoEventsPlaceholderText()
                    
                    Spacer()
                    
                case .events(let events, _):
                    ForEach(events) { (event) in
                        Link(destination: event.widgetURL) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(event.title)
                                        .font(.caption)
                                        .foregroundColor(Color.widgetContentForegroundPrimary)
                                        .lineLimit(1)
                                    
                                    Spacer()
                                    
                                    EventStartTime(event.formattedStartTime)
                                }
                                
                                Text(event.location)
                                    .font(.caption)
                                    .foregroundColor(Color.widgetContentForegroundSecondary)
                                    .lineLimit(1)
                            }
                        }
                        .padding(.trailing)
                        
                        if event != events.last {
                            Divider()
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding(.top)
    }
    
}
