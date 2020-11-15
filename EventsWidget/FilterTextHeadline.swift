import SwiftUI
import WidgetKit

struct FilterTextHeadline: View {
    
    var filter: EventFilter
    
    var body: some View {
        text
            .font(.title2)
    }
    
    @ViewBuilder
    private var text: some View {
        switch filter {
        case .upcoming:
            Text("Upcoming", comment: "Upcoming")
            
        case .favourites:
            Text("Favourites", comment: "Favourites")
            
        case .running:
            Text("Running", comment: "Running")
            
        case .unknown:
            Text("")
        }
    }
    
}
