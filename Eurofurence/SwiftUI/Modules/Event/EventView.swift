import EurofurenceKit
import Logging
import SwiftUI

struct EventView: View {
    
    @ObservedObject var event: Event
    @State private var feedbackForm: Event.FeedbackForm?
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @ScaledMetric(relativeTo: .body) private var intersectionSpacing: CGFloat = 7
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                EventHeading(event: event)
                    .padding(.bottom, intersectionSpacing)
                
                if (event.tags.isEmpty || event.eventDescription.isEmpty) == false {
                    Divider()
                        .padding(.bottom, intersectionSpacing)
                    
                    EventTags(event: event)
                    
                    MarkdownContent(event.eventDescription)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                ToggleEventFavouriteStateButton(event: event) {
                    FavouriteIcon(filled: event.isFavourite)
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                EurofurenceShareLink(url: event.contentURL, title: event.title)
            }
            
            ToolbarItem(placement: .bottomBar) {
                ToggleCalendarPresenceButton(event: event)
            }
            
            ToolbarItem(placement: .bottomBar) {
                if event.acceptingFeedback {
                    Button {
                        do {
                            feedbackForm = try event.prepareFeedback()
                        } catch {
                            Logger.ui.error(
                                "Failed to prepare feedback form for event",
                                metadata: [
                                    "EventID": .string(event.id),
                                    "Error": .string(String(describing: error))
                                ]
                            )
                        }
                    } label: {
                        Label {
                            Text("Leave Feedback")
                        } icon: {
                            Image(systemName: "square.and.pencil")
                        }
                    }
                }
            }
        }
        .sheet(item: $feedbackForm) { feedbackForm in
            EventFeedbackForm(event: event, feedback: feedbackForm)
        }
    }
    
    private struct EventHeading: View {
        
        @ObservedObject var event: Event
        @Environment(\.dynamicTypeSize) private var dynamicTypeSize
        @ScaledMetric(relativeTo: .body) private var eventTimesToSubtitleSpacing: CGFloat = 10
        
        var body: some View {
            VStack(alignment: .leading) {
                if let poster = event.poster {
                    EurofurenceKitImage(image: poster, permitsFullscreenInteraction: true)
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
                    
                    EventHostsLabel(event)
                        .foregroundColor(.blue)
                    
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
                AlignedLabelContainer {
                    ForEach(event.canonicalTags) { tag in
                        HStack {
                            CanonicalTagLabel(tag)
                                .foregroundColor(.pantone330U)
                            
                            Spacer()
                        }
                        .padding(.bottom, interTagSpacing)
                        
                        Divider()
                            .padding(.bottom, interTagSpacing)
                    }
                }
            }
        }
        
    }
    
    private struct ToggleCalendarPresenceButton: View {
        
        @ObservedObject var event: Event
        @Environment(\.selectionChangedHaptic) private var selectionChangedHaptic
        @State private var statusOverlayVisible = false
        
        var body: some View {
            Button {
                statusOverlayVisible = true
                selectionChangedHaptic()
                
                if event.isPresentInCalendar {
                    event.removeFromCalendar()
                } else {
                    event.addToCalendar()
                }
            } label: {
                if event.isPresentInCalendar {
                    Label {
                        Text("Remove from Calendar")
                    } icon: {
                        Image(systemName: "calendar.badge.minus")
                    }
                } else {
                    Label {
                        Text("Add to Calendar")
                    } icon: {
                        Image(systemName: "calendar.badge.plus")
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
            
            let dealersDen = model.event(for: .dealersDen)
            NavigationView {
                EventView(event: dealersDen)
            }
            .previewDisplayName(dealersDen.title)
        }
    }
    
}
