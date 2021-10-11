import EventsWidgetLogic
import SwiftUI

struct SmallEventsWidget: View {
    
    var entry: EventTimelineEntry
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                LargeCalendarIcon()
                Spacer()
                EntryEventsCountView(entry: entry)
            }
            
            Spacer()
            
            CategoryTextHeadline(category: entry.context.category)
            
            switch entry.content {
            case .empty:
                NoEventsPlaceholderText()
                    .font(.caption)
                
            case .events(let events, _):
                ForEach(events) { (event) in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(event.title)
                                .font(.caption)
                                .foregroundColor(.widgetContentForegroundPrimary)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            EventStartTime(event.formattedStartTime)
                        }
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
