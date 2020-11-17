import SwiftUI

struct AdditionalEventsFooter: View {
    
    var additionalEventsCount: Int
    
    var body: some View {
        if additionalEventsCount > 0 {
            Text(verbatim: .additionalEventsFooter(remaining: additionalEventsCount))
                .font(.caption2)
        }
    }
    
}
