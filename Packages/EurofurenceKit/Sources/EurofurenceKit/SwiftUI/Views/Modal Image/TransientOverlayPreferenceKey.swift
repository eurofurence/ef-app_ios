import SwiftUI

extension View {
    
    /// Presents a minimally distruptive modal overlay atop the current view hiearchy.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to specify whether the overlay is currently presented.
    ///   - overlay: A view builder to produce the contents of the overlay. The closure accepts one parameter that
    ///              provides a namespace to coordinate geometric transitions during the presentation.
    /// - Returns: A modified view that presents the specified overlay.
    func transientOverlay<Overlay>(
        isPresented: Binding<Bool>,
        @ViewBuilder overlay: @escaping (Namespace.ID) -> Overlay
    ) -> some View where Overlay: View {
        self
            .preference(
                key: TransientOverlayPreferenceKey.self,
                value: TransientOverlayConfiguration(
                    isPresented: isPresented,
                    makeOverlay: { namespace in
                        AnyView(overlay(namespace))
                    }
                )
            )
    }
    
}

struct TransientOverlayPreferenceKey: PreferenceKey {
    
    typealias Value = TransientOverlayConfiguration?
    
    static func reduce(value: inout TransientOverlayConfiguration?, nextValue: () -> TransientOverlayConfiguration?) {
        if let next = nextValue() {
            value = next
        }
    }
    
}
