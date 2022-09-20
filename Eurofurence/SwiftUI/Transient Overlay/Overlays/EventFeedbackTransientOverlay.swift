import EurofurenceKit
import SwiftUI

extension View {
    
    /// Enables transient overlays when event feedback is submitted and received by the events team.
    /// - Returns: A modified `View` that presents an overlay on successful feedback submission.
    func eventFeedbackTransientOverlay() -> some View {
        ModifiedContent(content: self, modifier: EnableFeedbackTransientOverlayViewModifier())
    }
    
}

private struct EnableFeedbackTransientOverlayViewModifier: ViewModifier {
    
    @State private var isFeedbackConfirmationPresented = false
    
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: .EFKEventFeedbackSubmitted)) { _ in
                isFeedbackConfirmationPresented = true
            }
            .transientOverlay(id: "Event Feedback Overlay", isPresented: $isFeedbackConfirmationPresented) { _ in
                FeedbackSentPopover()
            }
    }
    
}
