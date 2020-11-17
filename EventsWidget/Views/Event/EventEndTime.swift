import SwiftUI

struct EventEndTime: View {
    
    var formattedEndTime: String
    
    init(_ formattedEndTime: String) {
        self.formattedEndTime = formattedEndTime
    }
    
    var body: some View {
        Text(formattedEndTime)
            .lineLimit(1)
            .font(.caption2)
            .foregroundColor(.secondary)
    }
    
}
