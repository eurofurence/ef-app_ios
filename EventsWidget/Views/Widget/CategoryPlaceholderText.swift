import EventsWidgetLogic
import SwiftUI

struct CategoryPlaceholderText: View {
    
    var category: EventCategory
    
    var body: some View {
        text
            .multilineTextAlignment(.center)
            .foregroundColor(.primary)
    }
    
    @ViewBuilder
    private var text: some View {
        switch category {
        case .upcoming:
            Text("No upcoming events")
            
        case .running:
            Text("No running events")
        }
    }
    
}
