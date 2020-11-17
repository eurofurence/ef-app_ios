import SwiftUI

struct EventTitle: View {
    
    var title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .font(.caption)
            .fontWeight(.semibold)
            .lineLimit(1)
    }
    
}
