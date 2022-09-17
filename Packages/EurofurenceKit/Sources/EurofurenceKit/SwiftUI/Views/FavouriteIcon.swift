import SwiftUI

/// An icon used to denote favourites, and infer favourite state.
public struct FavouriteIcon: View {
    
    private let filled: Bool
    
    public init(filled: Bool) {
        self.filled = filled
    }
    
    public var body: some View {
        SwiftUI.Image(systemName: filled ? "heart.fill" : "heart")
            .foregroundColor(.red)
    }
    
}

struct FavouriteIcon_Previews: PreviewProvider {
    
    static var previews: some View {
        FavouriteIcon(filled: false)
            .previewDisplayName("Unfilled")
            .previewLayout(.sizeThatFits)
        
        FavouriteIcon(filled: true)
            .previewDisplayName("Filled")
            .previewLayout(.sizeThatFits)
    }
    
}
