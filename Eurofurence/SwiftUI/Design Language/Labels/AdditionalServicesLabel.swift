import SwiftUI

struct AdditionalServicesLabel: View {
    
    private var isSelected: Bool
    
    init(isSelected: Bool = false) {
        self.isSelected = isSelected
    }
    
    var body: some View {
        Label {
            Text("Services")
        } icon: {
            if isSelected {
                Image(systemName: "books.vertical.fill")
            } else {
                Image(systemName: "books.vertical")
            }
        }
    }
    
}

struct AdditionalServicesLabel_Previews: PreviewProvider {
    
    static var previews: some View {
        AdditionalServicesLabel()
            .previewLayout(.sizeThatFits)
        
        AdditionalServicesLabel(isSelected: true)
            .previewLayout(.sizeThatFits)
    }
    
}
