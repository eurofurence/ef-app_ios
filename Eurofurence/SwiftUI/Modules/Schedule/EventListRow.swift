import EurofurenceKit
import SwiftUI

struct EventListRow: View {
    
    @ObservedObject var event: Event
    @ScaledMetric(relativeTo: .body) private var rowHeight: CGFloat = 72
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    FormattedShortTime(event.startDate)
                        .font(.body)
                    
                    FormattedShortTime(event.endDate)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .alignmentGuide(.leading) { dimensions in
                            dimensions[.leading] - 14
                        }
                }
                
                VStack(alignment: .leading) {
                    Text(event.title)
                    
                    Text(event.room.name)
                        .foregroundColor(.secondary)
                }
            }
            
            if let banner = event.banner {
                EurofurenceKitImage(image: banner)
            }
        }
        .frame(minHeight: rowHeight)
    }
    
}

struct EventListRow_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { model in
            // Registration - no images, fairly standard
            EventListRow(event: model.event(for: .registration))
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Registration")
            
            EventListRow(event: model.event(for: .bootyBounce))
                .previewLayout(.sizeThatFits)
                .previewDisplayName("The Booty Bouce")
        }
    }
    
}
