import SwiftUI

/// A root view for managing the presentation of images with a modal transition.
///
/// This view should occur at or near the root of the app's view hiearchy in order for child views to publish images
/// that need modal transition via the ``modalImage(id:isPresented:image:)`` view modifier.
public struct ModalImageContainer<Content>: View where Content: View {
    
    private let content: () -> Content
    @State private var presentedImage: ModallyPresentedImage?
    
    public init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        ZStack {
            content()
                .onChangeOfModallyPresentedImage { newValue in
                    withAnimation {
                        presentedImage = newValue
                    }
                }
            
            pannableImage
        }
    }
    
    @ViewBuilder private var pannableImage: some View {
        if let presentedImage = presentedImage {
            PannableFullScreenImage(image: presentedImage.image, isPresented: presentedImage.isPresented)
                .background(.ultraThinMaterial)
                .accessibilityAddTraits(.isModal)
        }
    }
    
}


