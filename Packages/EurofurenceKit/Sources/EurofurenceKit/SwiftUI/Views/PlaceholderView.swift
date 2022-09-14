import SwiftUI

/// A `View` used as a placeholder for a content pane that contains no data.
public struct PlaceholderView: View {
    
    public init() {
        
    }
    
    public var body: some View {
        SwiftUI.Image(decorative: "No Content Placeholder", bundle: .module)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 240)
            .foregroundColor(.gray)
    }
    
}

struct PlaceholderView_Previews: PreviewProvider {
    
    static var previews: some View {
        PlaceholderView()
    }
    
}
