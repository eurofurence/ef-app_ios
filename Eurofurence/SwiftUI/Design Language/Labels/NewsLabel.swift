import SwiftUI

struct NewsLabel: View {
    
    private var isSelected: Bool
    
    init(isSelected: Bool = false) {
        self.isSelected = isSelected
    }
    
    var body: some View {
        Label {
            Text("News")
        } icon: {
            if isSelected {
                Image(systemName: "newspaper.fill")
            } else {
                Image(systemName: "newspaper")
            }
        }
    }
    
}

struct NewsLabel_Previews: PreviewProvider {
    
    static var previews: some View {
        NewsLabel()
            .previewLayout(.sizeThatFits)
        
        NewsLabel(isSelected: true)
            .previewLayout(.sizeThatFits)
    }
    
}
