import SwiftUI

/// A root view for managing the presentation of images with a modal transition.
///
/// This view should occur at or near the root of the app's view hiearchy in order for child views to publish images
/// that need modal transition via the ``modalImage(id:isPresented:image:)`` view modifier.
public struct TransientOverlayContainer<Content>: View where Content: View {
    
    private let content: () -> Content
    @State private var currentOverlay: TransientOverlayConfiguration?
    @Namespace private var transientOverlayNamespace
    
    public init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        ZStack {
            content()
                .environment(\.transientOverlayNamespace, transientOverlayNamespace)
                .onPreferenceChange(TransientOverlayPreferenceKey.self) { newValue in
                    withAnimation {
                        currentOverlay = newValue
                    }
                }
                .overlay(transientOverlay)
        }
    }
    
    @ViewBuilder private var transientOverlay: some View {
        if let currentOverlay = currentOverlay {
            CurrentOverlay(
                isPresented: currentOverlay.isPresented,
                namespace: transientOverlayNamespace,
                makeOverlay: currentOverlay.makeOverlay
            )
        }
    }
    
    private struct CurrentOverlay: View {
        
        @Binding var isPresented: Bool
        var namespace: Namespace.ID
        var makeOverlay: (Namespace.ID) -> AnyView
        
        var body: some View {
            if isPresented {
                makeOverlay(namespace)
                    .accessibilityAddTraits(.isModal)
            }
        }
        
    }
    
}

extension EnvironmentValues {
    
    var transientOverlayNamespace: Namespace.ID? {
        get {
            self[ModalImageNamespaceEnvironmentKey.self]
        }
        set {
            self[ModalImageNamespaceEnvironmentKey.self] = newValue
        }
    }
    
    private struct ModalImageNamespaceEnvironmentKey: EnvironmentKey {
        
        typealias Value = Namespace.ID?
        
        static var defaultValue: Namespace.ID?
        
    }
    
}
