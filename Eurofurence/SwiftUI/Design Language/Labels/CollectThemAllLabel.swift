import SwiftUI

struct CollectThemAllLabel: View {
    
    private var isSelected: Bool
    
    init(isSelected: Bool = false) {
        self.isSelected = isSelected
    }
    
    var body: some View {
        Label {
            Text("Collect-them-All")
        } icon: {
            // NB: We don't have a selected state image for the collect them all. We'll pass in the isSelected
            // state in anticipation we wind up with one down the road.
            Image("Collectemall-50")
        }
    }
    
}

struct CollectThemAllLabel_Previews: PreviewProvider {
    
    static var previews: some View {
        CollectThemAllLabel()
            .previewLayout(.sizeThatFits)
        
        CollectThemAllLabel(isSelected: true)
            .previewLayout(.sizeThatFits)
    }
    
}
