import SwiftUI

struct MapsLabel: View {
    
    private var isSelected: Bool
    
    init(isSelected: Bool = false) {
        self.isSelected = isSelected
    }
    
    var body: some View {
        Label {
            Text("Maps")
        } icon: {
            if isSelected {
                Image(systemName: "map.fill")
            } else {
                Image(systemName: "map")
            }
        }
    }
    
}

struct MapsLabel_Previews: PreviewProvider {
    
    static var previews: some View {
        MapsLabel()
            .previewLayout(.sizeThatFits)
        
        MapsLabel(isSelected: true)
            .previewLayout(.sizeThatFits)
    }
    
}
