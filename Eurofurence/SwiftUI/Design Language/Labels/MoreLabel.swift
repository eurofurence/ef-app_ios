import SwiftUI

struct MoreLabel: View {
    
    private var isSelected: Bool
    
    init(isSelected: Bool = false) {
        self.isSelected = isSelected
    }
    
    var body: some View {
        Label {
            Text("More")
        } icon: {
            Image(systemName: "ellipsis")
        }
    }
    
}

struct MoreLabel_Previews: PreviewProvider {
    
    static var previews: some View {
        MoreLabel()
            .previewLayout(.sizeThatFits)
        
        MoreLabel(isSelected: true)
            .previewLayout(.sizeThatFits)
    }
    
}
