import SwiftUI
import WidgetKit

struct EventFilterText: View {
    
    var filter: Filter
    
    var body: some View {
        text.font(.headline)
    }
    
    @ViewBuilder
    private var text: some View {
        switch filter {
        case .upcoming:
            Text("Upcoming")
            
        case .favourites:
            Text("Favourites")
            
        case .running:
            Text("Running")
            
        case .unknown:
            Text("")
        }
    }
    
}
