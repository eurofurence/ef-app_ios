import SwiftUI

/// A `View` for rendering `Image` types from the EurofurenceKit package.
public struct EurofurenceKitImage: View {
    
    @ObservedObject private var image: EurofurenceKit.Image
    
    public init(image: EurofurenceKit.Image) {
        self.image = image
    }
    
    public var body: some View {
        swiftUIImage
            .aspectRatio(contentMode: .fit)
            .cornerRadius(7)
    }
    
    @ViewBuilder
    private var swiftUIImage: some View {
        if let url = image.cachedImageURL {
            if let uiImage = UIImage(contentsOfFile: url.path) {
                SwiftUI.Image(uiImage: uiImage)
                    .resizable()
            }
        }
    }
    
}
