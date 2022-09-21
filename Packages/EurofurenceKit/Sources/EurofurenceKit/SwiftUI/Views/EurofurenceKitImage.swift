import SwiftUI

extension EurofurenceKit.Image {
    
    /// Produces a platform-capable `Image` for presenting the contents of the receiver.
    public var image: SwiftUI.Image? {
        if let url = cachedImageURL {
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

/// A `View` for rendering `Image` types from the EurofurenceKit package.
public struct EurofurenceKitImage: View {
    
    @ObservedObject private var model: EurofurenceKit.Image
    @State private var isShowingFullScreen = false
    @State private var viewSize: CGSize = .zero
    private let permitsFullscreenInteraction: Bool
    
    public init(image: EurofurenceKit.Image, permitsFullscreenInteraction: Bool = false) {
        self.model = image
        self.permitsFullscreenInteraction = permitsFullscreenInteraction
    }
    
    public var body: some View {
        if let swiftUIImage = model.image {
            ZStack {
                if isShowingFullScreen {
                    Color
                        .clear
                        .frame(width: viewSize.width, height: viewSize.height)
                        .transition(.identity)
                } else {
                    swiftUIImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(7)
                        .allowsHitTesting(permitsFullscreenInteraction)
                        .onTapGesture {
                            if permitsFullscreenInteraction {                            
                                isShowingFullScreen = true
                            }
                        }
                        .measure { newSize in
                            viewSize = newSize
                        }
                        .transition(.identity)
                }
            }
            .fillsScenePannableImage(id: model.id, isPresented: $isShowingFullScreen, image: swiftUIImage.resizable())
        }
    }
    
}
