import SwiftUI

/// A `View` for rendering `Image` types from the EurofurenceKit package.
public struct EurofurenceKitImage: View {
    
    @ObservedObject private var image: EurofurenceKit.Image
    
    public init(image: EurofurenceKit.Image) {
        self.image = image
    }
    
    public var body: some View {
        AsyncImage(url: image.cachedImageURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            Color.gray
        }
    }
    
}
