import SwiftUI

struct EventLocation: View {
    
    var location: String
    
    init(_ location: String) {
        self.location = location
    }
    
    var body: some View {
        Text(location)
            .lineLimit(1)
            .font(.caption2)
            .foregroundColor(.secondary)
    }
    
}
