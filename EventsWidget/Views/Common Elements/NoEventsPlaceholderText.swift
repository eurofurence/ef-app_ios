import SwiftUI

struct NoEventsPlaceholderText: View {
    
    var body: some View {
        Text(
            "No Events",
            comment: "Placeholder text shown when the events widget contains no events"
        )
        .lineLimit(nil)
        .multilineTextAlignment(.center)
        .foregroundColor(.widgetContentForegroundSecondary)
    }
    
}
