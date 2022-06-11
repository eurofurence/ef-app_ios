import EventsWidgetLogic
import SwiftUI
import WidgetKit

struct CategoryTextHeadline: View {
    
    var category: EventCategory
    
    var body: some View {
        text
            .fontWeight(.semibold)
            .font(.subheadline)
            .foregroundColor(Color.widgetContentForegroundPrimary)
            .accessibilityHidden(true)
    }
    
    private var text: Text {
        switch category {
        case .upcoming:
            return Text("Upcoming", comment: "Upcoming")
            
        case .running:
            return Text("Running", comment: "Running")
        }
    }
    
}
