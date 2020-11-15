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
