import SwiftUI

/// Collates a group of overlays for presentation within the current environment.
class TransientOverlays: ObservableObject {
    
    /// The collection of visible overlays.
    @Published private(set) var overlays = [TransientOverlay]()
    
    /// Registers an overlay for presentation management.
    ///
    /// If the overlay requests presentation, it will be shown straight away.
    func register(overlay: TransientOverlay) {
        withTransaction(Transaction()) {
            overlays.append(overlay)
        }
    }
    
    /// Unregisters an overlay for presentation management.
    ///
    /// If the overlay is currently presented, it will be dismissed.
    func unregister(overlay: TransientOverlay) {
        withTransaction(Transaction()) {
            overlays.removeAll(where: { $0.id == overlay.id })
        }
    }
    
}
