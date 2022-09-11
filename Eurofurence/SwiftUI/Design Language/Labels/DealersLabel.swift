import SwiftUI

struct DealersLabel: View {
    
    private var isSelected: Bool
    
    init(isSelected: Bool = false) {
        self.isSelected = isSelected
    }
    
    var body: some View {
        Label {
            Text("Dealers")
        } icon: {
            if isSelected {
                Image(systemName: "cart.fill")
            } else {
                Image(systemName: "cart")
            }
        }
    }
    
}

struct DealersLabel_Previews: PreviewProvider {
    
    static var previews: some View {
        DealersLabel()
            .previewLayout(.sizeThatFits)
        
        DealersLabel(isSelected: true)
            .previewLayout(.sizeThatFits)
    }
    
}
