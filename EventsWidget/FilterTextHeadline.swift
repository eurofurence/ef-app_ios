import SwiftUI
import WidgetKit

struct FilterTextHeadline: View {
    
    var filter: EventFilter
    
    var body: some View {
        text
            .font(.caption)
    }
    
    @ViewBuilder
    private var text: some View {
        switch filter {
        case .upcoming:
            Text("Upcoming", comment: "Upcoming")
            
        case .running:
            Text("Running", comment: "Running")
            
        case .unknown:
            Text("")
        }
    }
    
}
