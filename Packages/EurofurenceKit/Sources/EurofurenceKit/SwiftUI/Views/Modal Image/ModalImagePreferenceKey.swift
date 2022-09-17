import SwiftUI

extension View {
    
    /// Requests the presentation, or dismissal, of a modally presented image.
    ///
    /// - Parameter image: The modally presented image to present, or `nil` if a previously presented image should be
    ///                    dismissed.
    /// - Returns: A modified `View` that will modally present or dismiss an image.
    func modallyPresentedImage(_ image: ModallyPresentedImage?) -> some View {
        self
            .preference(key: ModalImagePreferenceKey.self, value: image)
    }
    
    /// Adds an action to perform when an image is to be modally presented or dismissed.
    ///
    /// - Parameter onChange: The action to perform when a request to present or dismiss an image occurs.
    /// - Returns: A view that triggers the provided closure when an image is to be presented or dismissed.
    func onChangeOfModallyPresentedImage(_ onChange: @escaping (ModallyPresentedImage?) -> Void) -> some View {
        self
            .onPreferenceChange(ModalImagePreferenceKey.self, perform: onChange)
    }
    
}

private struct ModalImagePreferenceKey: PreferenceKey {
    
    typealias Value = ModallyPresentedImage?
    
    static func reduce(value: inout ModallyPresentedImage?, nextValue: () -> ModallyPresentedImage?) {
        if let next = nextValue() {
            value = next
        }
    }
    
}
