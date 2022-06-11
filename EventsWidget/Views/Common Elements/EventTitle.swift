import EventsWidgetLogic
import SwiftUI

struct EventTitle: View {
    
    var event: EventViewModel
    
    init(_ event: EventViewModel) {
        self.event = event
    }
    
    var body: some View {
        Text(event.title)
            .font(.caption)
            .lineLimit(1)
            .foregroundColor(.widgetContentForegroundPrimary)
    }
    
}
