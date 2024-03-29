import EventsWidgetLogic
import SwiftUI

struct EntryEventsCountView: View {
    
    var entry: EventTimelineEntry
    
    var body: some View {
        Text(NumberFormatter.localizedString(from: eventsCount as NSNumber, number: .decimal))
            .font(.title)
            .fontWeight(.semibold)
            .foregroundColor(Color.widgetContentForegroundPrimary)
            .accessibilityHidden(true)
    }
    
    private var eventsCount: Int {
        switch entry.content {
        case .empty:
            return 0
            
        case .events(let viewModels):
            return viewModels.count
        }
    }
    
}
