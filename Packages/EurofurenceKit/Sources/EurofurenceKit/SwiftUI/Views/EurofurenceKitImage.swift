import SwiftUI

/// A `View` for rendering `Image` types from the EurofurenceKit package.
public struct EurofurenceKitImage: View {
    
    @ObservedObject private var image: EurofurenceKit.Image
    @State private var isShowingFullScreen = false
    @State private var viewSize: CGSize = .zero
    private let permitsFullscreenInteraction: Bool
    
    public init(image: EurofurenceKit.Image, permitsFullscreenInteraction: Bool = false) {
        self.image = image
        self.permitsFullscreenInteraction = permitsFullscreenInteraction
    }
    
    public var body: some View {
        if let swiftUIImage = swiftUIImage {
            ZStack {
                if isShowingFullScreen {
                    Color
                        .clear
                        .frame(width: viewSize.width, height: viewSize.height)
                } else {
                    swiftUIImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(7)
                        .allowsHitTesting(permitsFullscreenInteraction)
                        .onTapGesture {
                            if permitsFullscreenInteraction {
                                withAnimation {                                
                                    isShowingFullScreen = true
                                }
                            }
                        }
                        .measure(onChange: { newSize in
                            viewSize = newSize
                        })
                }
            }
            .modalImage(id: image.id, isPresented: $isShowingFullScreen.animation(), image: swiftUIImage.resizable())
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
