import SwiftUI

struct AllEventsLabel: View {
    
    private var isSelected: Bool
    
    init(isSelected: Bool = false) {
        self.isSelected = isSelected
    }
    
    var body: some View {
        Label {
            Text("All Events")
        } icon: {
            Image(systemName: "calendar")
        }
    }
    
}

struct AllEventsLabel_Previews: PreviewProvider {
    
    static var previews: some View {
        AllEventsLabel()
            .previewLayout(.sizeThatFits)
        
        AllEventsLabel(isSelected: true)
            .previewLayout(.sizeThatFits)
    }
    
}
