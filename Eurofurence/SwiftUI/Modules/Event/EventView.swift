import EurofurenceKit
import SwiftUI

struct EventView: View {
    
    var event: Event
    @State private var isAboutExpanded = true
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @ScaledMetric(relativeTo: .body) private var intersectionSpacing: CGFloat = 7
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                EventHeading(event: event)
                    .padding(.bottom, intersectionSpacing)
                
                Divider()
                    .padding(.bottom, intersectionSpacing)
                
                EventTags(event: event)
                    .padding(.bottom, intersectionSpacing)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    // TODO: Add to/remove from calendar!
                } label: {
                    Label {
                        Text("Add to Calendar")
                    } icon: {
                        Image(systemName: "calendar.circle")
                    }
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                Button {
                    // TODO: Favourite/unfavourite!
                } label: {
                    Label {
                        Text("Leave Feedback")
                    } icon: {
                        Image(systemName: "square.and.pencil.circle")
                    }
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                Button {
                    // TODO: Favourite/unfavourite!
                } label: {
                    Label {
                        Text("Faourite")
                    } icon: {
                        Image(systemName: "heart.circle")
                    }
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button {
                    // TODO: Share!
                } label: {
                    Label {
                        Text("Share")
                    } icon: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
    }
    
    private struct EventHeading: View {
        
        @ObservedObject var event: Event
        @Environment(\.dynamicTypeSize) private var dynamicTypeSize
        @ScaledMetric(relativeTo: .body) private var eventTimesToSubtitleSpacing: CGFloat = 10
        
        var body: some View {
            VStack(alignment: .leading) {
                if let poster = event.poster {
                    EurofurenceKitImage(image: poster)
                }
                
                trackIndicator
                    .foregroundColor(.secondary)
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.secondary, lineWidth: 1)
                    )
                
                VStack(alignment: .leading, spacing: eventTimesToSubtitleSpacing) {
                    VStack(alignment: .leading) {
                        Text(event.title)
                            .font(.largeTitle.bold())
                        
                        if dynamicTypeSize > .xxxLarge {
                            VStack(alignment: .leading) {
                                startAndEndTimes
                            }
                            .foregroundColor(.secondary)
                        } else {
                            HStack {
                                startAndEndTimes
                            }
                            .foregroundColor(.secondary)
                        }
                        
                        Text(event.room.name)
                            .foregroundColor(.secondary)
                    }
                    
                    EventSubtitle(event)
                }
            }
        }
        
        @ViewBuilder private var trackIndicator: some View {
            if dynamicTypeSize > .xxxLarge {
                TrackText(event.track)
            } else {
                TrackLabel(event.track)
            }
        }
        
        @ViewBuilder private var startAndEndTimes: some View {
            Text(event.startDate, format: .dateTime.weekday(.wide))
            Text((event.startDate...event.endDate))
        }
        
    }
    
    private struct EventTags: View {
        
        @ObservedObject var event: Event
        @ScaledMetric(relativeTo: .body) private var interTagSpacing: CGFloat = 7
        
        var body: some View {
            if event.canonicalTags.isEmpty == false {
                VStack(alignment: .leading) {
                    ForEach(event.canonicalTags) { tag in
                        HStack {
                            CanonicalTagLabel(tag)
                                .foregroundColor(.pantone330U)
                            
                            Spacer()
                        }
                        .padding(.bottom, interTagSpacing)
                        
                        Divider()
                    }
                }
            }
        }
        
    }
    
}

struct EventView_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { model in
            let registration = model.event(for: .registration)
            NavigationView {
                EventView(event: registration)
            }
            .previewDisplayName(registration.title)
            
            let bootyBounce = model.event(for: .bootyBounce)
            NavigationView {
                EventView(event: bootyBounce)
            }
            .previewDisplayName(bootyBounce.title)
            
            let deadDog = model.event(for: .deadDog)
            NavigationView {
                EventView(event: deadDog)
            }
            .previewDisplayName(deadDog.title)
        }
    }
    
}
