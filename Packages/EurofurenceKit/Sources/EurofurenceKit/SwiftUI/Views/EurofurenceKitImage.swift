import SwiftUI

/// A `View` for rendering `Image` types from the EurofurenceKit package.
public struct EurofurenceKitImage: View {
    
    @ObservedObject private var image: EurofurenceKit.Image
    @State private var isShowingFullScreen = false
    private let permitsFullscreenInteraction: Bool
    
    public init(image: EurofurenceKit.Image, permitsFullscreenInteraction: Bool = false) {
        self.image = image
        self.permitsFullscreenInteraction = permitsFullscreenInteraction
    }
    
    public var body: some View {
        if let swiftUIImage = swiftUIImage {
            swiftUIImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(7)
                .onTapGesture {
                    if permitsFullscreenInteraction {
                        isShowingFullScreen = true
                    }
                }
                .modalImage(id: image.id, isPresented: $isShowingFullScreen, image: swiftUIImage.resizable())
        }
    }
    
    private var swiftUIImage: SwiftUI.Image? {
        if let url = image.cachedImageURL {
#if os(iOS)
            if let uiImage = UIImage(contentsOfFile: url.path) {
                return SwiftUI.Image(uiImage: uiImage)
            }
#elseif os(macOS)
            if let nsImage = NSImage(contentsOf: url) {
                return SwiftUI.Image(nsImage: nsImage)
            }
#endif
        }
        
        return nil
    }
    
}
