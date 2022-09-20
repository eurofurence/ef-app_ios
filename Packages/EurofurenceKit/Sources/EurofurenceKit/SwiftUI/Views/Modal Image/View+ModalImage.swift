import SwiftUI

extension View {
    
    /// A modifier that enables the receiver `View` to present an image in a transientally modal context.
    ///
    /// The image parameter will be presented on top of all other views within the current environment, with an
    /// appropriate backdrop to occlude the UI, allowing the user to pan and zoom the image to review details.
    ///
    /// - Parameters:
    ///   - id: A unique identity to associate with the presented image, for presentation-tracking purposes.
    ///   - isPresented: A binding to infer whether the image is currently being presented modally.
    ///   - image: The SwiftUI `Image` to present modally, atop the current scene.
    /// - Returns: A modified `View` that presents the provided image modally when `isPresented` is `true`.
    public func modalImage<ID>(
        id: ID,
        isPresented: Binding<Bool>,
        image: SwiftUI.Image
    ) -> some View where ID: Hashable {
        ModifiedContent(
            content: self,
            modifier: ModalImageViewModifier(
                id: id,
                isPresented: isPresented,
                image: image
            )
        )
    }
    
}

private struct ModalImageViewModifier<ID>: ViewModifier where ID: Hashable {
    
    let id: ID
    @Binding var isPresented: Bool
    let image: SwiftUI.Image
    @Environment(\.transientOverlayNamespace) private var transientOverlayNamespace
    
    func body(content: Content) -> some View {
        if let transientOverlayNamespace = transientOverlayNamespace {
            content
                .matchedGeometryEffect(
                    id: id,
                    in: transientOverlayNamespace
                )
                .transition(.offset())
                .transientOverlay(isPresented: $isPresented) { namespace in
                    PannableFullScreenImage(
                        image: image.matchedGeometryEffect(id: id, in: namespace),
                        isPresented: $isPresented
                    )
                    .background(.ultraThinMaterial)
                }
        } else {
            content
        }
    }
    
}
