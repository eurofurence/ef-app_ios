import SwiftUI

struct FormattedShortTime: View {
    
    private let date: Date
    
    init(_ date: Date) {
        self.date = date
    }
    
    var body: some View {
        Text(date, format: Date.FormatStyle(date: .omitted, time: .shortened))
    }
    
}
