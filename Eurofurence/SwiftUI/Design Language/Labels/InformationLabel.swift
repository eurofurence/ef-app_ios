import SwiftUI

struct InformationLabel: View {
    
    private let isSelected: Bool
    
    init(isSelected: Bool = false) {
        self.isSelected = isSelected
    }
    
    var body: some View {
        Label {
            Text("Information")
        } icon: {
            if isSelected {
                Image(systemName: "info.circle.fill")
            } else {
                Image(systemName: "info.circle")
            }
        }
    }
    
}

struct InformationLabel_Previews: PreviewProvider {
    
    static var previews: some View {
        InformationLabel()
            .previewLayout(.sizeThatFits)
        
        InformationLabel(isSelected: true)
            .previewLayout(.sizeThatFits)
    }
    
}
