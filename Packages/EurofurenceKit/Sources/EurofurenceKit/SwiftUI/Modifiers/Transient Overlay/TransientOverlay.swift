import SwiftUI

/// Defines an overlay view to be presented on top of the view hiearchy in a transient presentation style, e.g. passive
/// alerts.
class TransientOverlay: Equatable, Identifiable, ObservableObject {
    
    static func == (lhs: TransientOverlay, rhs: TransientOverlay) -> Bool {
        lhs.id == rhs.id
    }
    
    private let overlay: (Namespace.ID) -> AnyView
    
    init<ID, Overlay>(
        id: ID,
        isPresented: Bool,
        overlay: @escaping (Namespace.ID) -> Overlay
    ) where ID: Hashable, Overlay: View {
        self.id = AnyHashable(id)
        self.isPresented = isPresented
        self.overlay = { namespace in AnyView(overlay(namespace)) }
    }
    
    /// A stable identity for the overlay, typically sourced from a model object.
    let id: AnyHashable
    
    /// Designates whether this overlay is presented.
    @Published var isPresented: Bool
    
    /// Prepares the `View` to be rendered within the overlay described by the receiver.
    /// 
    /// - Parameter presentationNamespace: A `Namespace` in which presentation transitions will occur.
    /// - Returns: A type-erased `View` to present atop over views.
    func makeOverlay(presentationNamespace: Namespace.ID) -> AnyView {
        overlay(presentationNamespace)
    }
    
}
