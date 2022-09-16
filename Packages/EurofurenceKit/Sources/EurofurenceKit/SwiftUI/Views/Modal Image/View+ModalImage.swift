import SwiftUI

extension View {
    
    /// A modifier that enables the receiver `View` to present an image in a modal context.
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
                isPresented: isPresented,
                configuration: ModallyPresentedImage(id: id, isPresented: isPresented, image: image)
            )
        )
    }
    
}

private struct ModalImageViewModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    let configuration: ModallyPresentedImage
    
    func body(content: Content) -> some View {
        content
            .modallyPresentedImage(isPresented ? configuration : nil)
    }
    
}
