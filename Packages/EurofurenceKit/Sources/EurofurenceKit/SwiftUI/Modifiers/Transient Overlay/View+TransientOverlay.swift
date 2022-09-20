import SwiftUI

extension View {
    
    /// Presents a minimally distruptive modal overlay atop the current view hiearchy.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to specify whether the overlay is currently presented.
    ///   - overlay: A view builder to produce the contents of the overlay. The closure accepts one parameter that
    ///              provides a namespace to coordinate geometric transitions during the presentation.
    /// - Returns: A modified view that presents the specified overlay.
    public func transientOverlay<ID, Overlay>(
        id: ID,
        isPresented: Binding<Bool>,
        @ViewBuilder overlay: @escaping (Namespace.ID) -> Overlay
    ) -> some View where ID: Hashable, Overlay: View {
        ModifiedContent(
            content: self,
            modifier: TransientOverlayViewModifier(
                isPresented: isPresented,
                configuration: TransientOverlay(
                    id: id,
                    isPresented: isPresented.wrappedValue,
                    overlay: overlay
                )
            )
        )
    }
    
}

private struct TransientOverlayViewModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    @State var configuration: TransientOverlay
    @EnvironmentObject private var overlays: TransientOverlays
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                overlays.register(overlay: configuration)
            }
            .onDisappear {
                overlays.unregister(overlay: configuration)
            }
            .onChange(of: isPresented) { newValue in
                withAnimation(.spring()) {
                    configuration.isPresented = newValue
                }
            }
    }
    
}
