import SwiftUI

struct LargeCalendarIcon: View {
    
    private let sensibleLengthForDisplay: CGFloat = 34
    
    var body: some View {
        Image(systemName: "calendar.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: sensibleLengthForDisplay, height: sensibleLengthForDisplay)
            .foregroundColor(Color.widgetContentForegroundPrimary)
    }
    
}
