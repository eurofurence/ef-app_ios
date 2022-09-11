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
            icon
                .foregroundColor(.red)
        }
    }
    
    @ViewBuilder private var icon: some View {
        if isSelected {
            Image(systemName: "heart.fill")
        } else {
            Image(systemName: "heart")
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
