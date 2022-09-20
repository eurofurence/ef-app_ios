import SwiftUI

extension View {
    
    /// Enables transient overlays within the application sourced from events published by the model.
    /// - Returns: A modified `View` that presents overlays in response to model updates.
    func applicationTransientOverlays() -> some View {
        self
            .eventFeedbackTransientOverlay()
    }
    
}
