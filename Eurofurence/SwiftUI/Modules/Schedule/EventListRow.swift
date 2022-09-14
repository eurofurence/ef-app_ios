import EurofurenceKit
import SwiftUI

struct EventListRow: View {
    
    @ObservedObject var event: Event
    @ScaledMetric(relativeTo: .body) private var rowHeight: CGFloat = 72
    
    var body: some View {
        VStack(alignment: .leading) {
            EventSummary(event: event)
            
            if let banner = event.banner {
                EurofurenceKitImage(image: banner)
            }
        }
        .frame(minHeight: rowHeight)
    }
    
    private struct EventSummary: View {
        
        var event: Event
        @ScaledMetric(relativeTo: .body) private var headingAndContentSpacing: CGFloat = 3
        @Environment(\.dynamicTypeSize) private var dynamicTypeSize: DynamicTypeSize
        
        var body: some View {
            VStack(alignment: .leading, spacing: headingAndContentSpacing) {
                Heading(event: event)
                Detail(event: event)
            }
        }
        
    }
    
    private struct Heading: View {
        
        var event: Event
        @Environment(\.dynamicTypeSize) private var dynamicTypeSize: DynamicTypeSize
        
        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    if dynamicTypeSize < .accessibility1 {
                        Text("\(event.room.shortName) • \(event.track.name)")
                    } else {
                        VStack(alignment: .leading) {
                            Text(event.room.shortName)
                            Text(event.track.name)
                        }
                    }
                    
                    Spacer()
                    
                    if dynamicTypeSize < .xxxLarge {
                        eventTags
                        
                        if dynamicTypeSize < .xLarge {
                            startTime
                        }
                    }
                }
                
                if dynamicTypeSize >= .xLarge {
                    HStack {
                        startTime
                        
                        if dynamicTypeSize >= .xxxLarge && dynamicTypeSize < .accessibility3 {
                            Spacer()
                            eventTags
                        }
                    }
                }
                
                if dynamicTypeSize >= .accessibility3 {
                    HStack {
                        eventTags
                    }
                }
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        
        @ViewBuilder private var startTime: some View {
            FormattedShortTime(event.startDate)
        }
        
        @ViewBuilder private var eventTags: some View {
            ForEach(event.canonicalTags) { tag in
                CanonicalTagIcon(tag)
            }
        }
        
    }
    
    private struct Detail: View {
        
        var event: Event
        @Environment(\.dynamicTypeSize) private var dynamicTypeSize: DynamicTypeSize
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(event.title)
                    .font(.headline)
                
                if let abstract = event.abstract, dynamicTypeSize < .accessibility1 {
                    MarkdownContent(abstract)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
        }
        
    }
    
}

struct EventListRow_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { model in
            EventListRow(event: model.event(for: .registration))
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Registration")
            
            EventListRow(event: model.event(for: .bootyBounce))
                .previewLayout(.sizeThatFits)
                .previewDisplayName("The Booty Bouce")
        }
    }
    
}
