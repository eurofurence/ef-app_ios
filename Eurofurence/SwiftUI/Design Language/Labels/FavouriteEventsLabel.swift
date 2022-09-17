import EurofurenceKit
import SwiftUI

struct FavouriteEventsLabel: View {
    
    private var isSelected: Bool
    
    init(isSelected: Bool = false) {
        self.isSelected = isSelected
    }
    
    var body: some View {
        Label {
            Text("Schedule")
        } icon: {
            FavouriteIcon(filled: true)
        }
    }
    
}

struct FavouriteEventsLabel_Previews: PreviewProvider {
    
    static var previews: some View {
        FavouriteEventsLabel()
            .previewLayout(.sizeThatFits)
        
        FavouriteEventsLabel(isSelected: true)
            .previewLayout(.sizeThatFits)
    }
    
}
