import EurofurenceKit
import SwiftUI

struct EventListRow: View {
    
    struct Configuration {
        var displayTrackName: Bool
        var displayRoomName: Bool
    }
    
    @ObservedObject var event: Event
    var configuration: Configuration
    @ScaledMetric(relativeTo: .body) private var rowHeight: CGFloat = 72
    
    var body: some View {
        VStack(alignment: .leading) {
            EventSummary(event: event, configuration: configuration)
            
            if let banner = event.banner {
                EurofurenceKitImage(image: banner)
            }
        }
        .frame(minHeight: rowHeight)
    }
    
    private struct EventSummary: View {
        
        var event: Event
        var configuration: Configuration
        @ScaledMetric(relativeTo: .body) private var headingAndContentSpacing: CGFloat = 3
        @Environment(\.dynamicTypeSize) private var dynamicTypeSize: DynamicTypeSize
        
        var body: some View {
            VStack(alignment: .leading, spacing: headingAndContentSpacing) {
                Heading(event: event, configuration: configuration)
                Detail(event: event)
            }
        }
        
    }
    
    private struct Heading: View {
        
        @ObservedObject var event: Event
        var configuration: Configuration
        @Environment(\.dynamicTypeSize) private var dynamicTypeSize: DynamicTypeSize
        
        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    if dynamicTypeSize < .accessibility1 {
                        inlineHeadingSummary
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
                            .padding(.bottom, 3)
                        
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
        
        private var inlineHeadingSummary: some View {
            var components = [String]()
            if configuration.displayRoomName {
                components.append(event.room.shortName)
            }
            
            if configuration.displayTrackName {
                components.append(event.track.name)
            }
            
            if components.isEmpty {
                return AnyView(EmptyView())
            }
            
            if components.count == 1 {
                return AnyView(Text(components[0]))
            }
            
            return AnyView(Text("\(components[0]) • \(components[1])"))
        }
        
        @ViewBuilder private var startTime: some View {
            FormattedShortTime(event.startDate)
        }
        
        @ViewBuilder private var eventTags: some View {
            if event.isFavourite {
                FavouriteIcon(filled: true)
            }
            
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
                
                if dynamicTypeSize < .accessibility1 {
                    EventSubtitle(event)
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
            EventListRow(
                event: model.event(for: .registration),
                configuration: .init(displayTrackName: true, displayRoomName: true)
            )
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Registration")
            
            EventListRow(
                event: model.event(for: .bootyBounce), 
                configuration: .init(displayTrackName: true, displayRoomName: true)
            )
            .previewLayout(.sizeThatFits)
            .previewDisplayName("The Booty Bouce")
        }
    }
    
}
