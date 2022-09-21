import SwiftUI

extension View {
    
    /// Presents a minimally distruptive modal overlay atop the current view hiearchy.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for the overlay, typically scoped to the identity of the content to present.
    ///   - isPresented: A binding to specify whether the overlay is currently presented.
    ///   - transiency: The transiency interval of the overlay, designating the interval the overlay will be visible
    ///                 for.
    ///   - overlay: A view builder to produce the contents of the overlay. The closure accepts one parameter that
    ///              provides a namespace to coordinate geometric transitions during the presentation.
    /// - Returns: A modified view that presents the specified overlay.
    public func transientOverlay<ID, Overlay>(
        id: ID,
        isPresented: Binding<Bool>,
        transiency: TransiencyInterval = .brief(seconds: 3),
        @ViewBuilder overlay: @escaping (Namespace.ID) -> Overlay
    ) -> some View where ID: Hashable, Overlay: View {
        ModifiedContent(
            content: self,
            modifier: TransientOverlayViewModifier(
                isPresented: isPresented,
                overlay: TransientOverlay(
                    id: id,
                    isPresented: isPresented.wrappedValue,
                    transiency: transiency,
                    overlay: overlay
                )
            )
        )
    }
    
}

/// Designates the transiency of a transient overlay.
public enum TransiencyInterval {
    
    /// The overlay should remain until dismissed. The overlay must provide a method to dismiss the overlay.
    case indefinite
    
    /// The overlay should remain for a set number of seconds. The overlay should not provide any interactive
    /// controls.
    case brief(seconds: TimeInterval)
    
}

private struct TransientOverlayViewModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    @State var overlay: TransientOverlay
    @EnvironmentObject private var overlays: TransientOverlays
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                overlays.register(overlay: overlay)
            }
            .onDisappear {
                overlays.unregister(overlay: overlay)
            }
            .onChange(of: isPresented) { newValue in
                withAnimation(.spring()) {
                    overlay.isPresented = newValue
                }
            }
    }
    
}
