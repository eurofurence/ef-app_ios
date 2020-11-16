import SwiftUI
import WidgetKit

struct FilterTextHeadline: View {
    
    var filter: EventFilter
    
    var body: some View {
        text
            .fontWeight(.heavy)
            .font(.caption)
    }
    
    private var text: Text {
        switch filter {
        case .upcoming:
            return Text("Upcoming", comment: "Upcoming")
            
        case .running:
            return Text("Running", comment: "Running")
            
        case .unknown:
            return Text("")
        }
    }
    
}
