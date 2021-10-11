import SwiftUI

struct EventStartTime: View {
    
    var formattedStartTime: String
    
    init(_ formattedStartTime: String) {
        self.formattedStartTime = formattedStartTime
    }
    
    var body: some View {
        Text(formattedStartTime)
            .lineLimit(1)
            .font(.caption2)
            .foregroundColor(.widgetContentForegroundPrimary)
    }
    
}
