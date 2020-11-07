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
            Text(NSLocalizedString("Upcoming", comment: "Upcoming").localizedCapitalized)
            
        case .favourites:
            Text(NSLocalizedString("Favourites", comment: "Favourites").localizedCapitalized)
            
        case .running:
            Text(NSLocalizedString("Running", comment: "Running").localizedCapitalized)
            
        case .unknown:
            Text("")
        }
    }
    
}
