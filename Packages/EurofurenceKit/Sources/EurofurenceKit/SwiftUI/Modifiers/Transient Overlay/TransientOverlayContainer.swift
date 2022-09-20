import SwiftUI

/// A root view for managing the presentation of views within a transient modal context.
///
/// This view should occur at or near the root of the app's view hiearchy in order for child views to publish images
/// that need modal transition via the ``transientOverlay(id:isPresented:overlay:)`` modifier.
public struct TransientOverlayContainer<Content>: View where Content: View {
    
    private let content: Content
    @StateObject private var transientOverlays = TransientOverlays()
    @Namespace private var transientOverlayNamespace
    
    public init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            .environmentObject(transientOverlays)
            .environment(\.transientOverlayNamespace, transientOverlayNamespace)
            .overlay(
                TransientOverlaysView(
                    transientOverlays: transientOverlays,
                    transientOverlayNamespace: transientOverlayNamespace
                )
            )
    }
    
    private struct TransientOverlaysView: View {
        
        @ObservedObject var transientOverlays: TransientOverlays
        var transientOverlayNamespace: Namespace.ID
        
        var body: some View {
            ZStack {
                ForEach(transientOverlays.overlays) { transientOverlay in
                    TransientOverlayView(
                        transientOverlay: transientOverlay,
                        transientOverlayNamespace: transientOverlayNamespace
                    )
                }
            }
        }
        
    }
    
    private struct TransientOverlayView: View {
        
        @ObservedObject var transientOverlay: TransientOverlay
        var transientOverlayNamespace: Namespace.ID
        
        var body: some View {
            if transientOverlay.isPresented {
                transientOverlay
                    .makeOverlay(presentationNamespace: transientOverlayNamespace)
                    .accessibilityAddTraits(.isModal)
            }
        }
        
    }
    
}
