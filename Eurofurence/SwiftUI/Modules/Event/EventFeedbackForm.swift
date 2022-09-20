import EurofurenceKit
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

extension Color {
    
    static var formHeading: Color {
#if canImport(UIKit)
        return Color(uiColor: .systemGroupedBackground)
#else
        return .clear
#endif
    }
    
}

struct EventFeedbackForm: View {
    
    @ObservedObject var event: Event
    @ObservedObject var feedback: Event.FeedbackForm
    @State private var isPresentingDiscardAlert = false
    @State private var state: FeedbackState = .preparing
    @State private var feedbackSubmissionError: Error?
    @State private var isPresentingFeedbackSubmissionErrorAlert = false
    @Environment(\.dismiss) private var dismiss
    
    private enum FeedbackState {
        case preparing
        case sending
        case sent
    }
    
    var body: some View {
        NavigationView {
            EditFeedbackForm(event: event, feedback: feedback)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            isPresentingDiscardAlert = true
                        } label: {
                            Text("Cancel")
                        }
                        .disabled(state == .sending)
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            sendFeedback()
                        } label: {
                            if state == .sending {
                                ProgressView()
                            } else {
                                Text("Send")
                                    .bold()
                            }
                        }
                        .disabled(state == .sending)
                    }
                }
                .alert("Discard Feedback", isPresented: $isPresentingDiscardAlert) {
                    Button(role: .cancel) {
                        isPresentingDiscardAlert = false
                    } label: {
                        Text("Continue Editing")
                    }
                    
                    Button(role: .destructive) {
                        dismiss()
                    } label: {
                        Text("Discard")
                    }
                }
                .navigationTitle("Event Feedback")
                .navigationBarTitleDisplayMode(.inline)
                .interactiveDismissDisabled()
                .alert("Feedback Not Sent", isPresented: $isPresentingFeedbackSubmissionErrorAlert, presenting: feedbackSubmissionError) { _ in
                    Button {
                        sendFeedback()
                    } label: {
                        Text("Try Again")
                    }
                    
                    Button(role: .cancel) {
                        
                    } label: {
                        Text("Cancel")
                    }
                }
        }
    }
    
    private func sendFeedback() {
        withAnimation {
            state = .sending
        }
        
        Task(priority: .userInitiated) {
            do {
                try await feedback.submit()
                dismiss()
            } catch {
                withAnimation {
                    isPresentingFeedbackSubmissionErrorAlert = true
                    feedbackSubmissionError = error
                    state = .preparing
                }
            }
        }
    }
    
    private struct EditFeedbackForm: View {
        
        @ObservedObject var event: Event
        @ObservedObject var feedback: Event.FeedbackForm
        @ScaledMetric(relativeTo: .body) private var titleToLocationSpacing: CGFloat = 10
        
        var body: some View {
            Form {
                heading
                inputControls
            }
        }
        
        @ViewBuilder private var heading: some View {
            HStack {
                VStack(alignment: .leading, spacing: titleToLocationSpacing) {
                    Text(verbatim: event.title)
                        .font(.largeTitle)
                        .bold()
                    
                    VStack {
                        AlignedLabelContainer {
                            Label {
                                Text(verbatim: event.day.name)
                            } icon: {
                                Image(systemName: "calendar")
                            }
                            
                            Label {
                                FormattedShortTime(event.startDate)
                            } icon: {
                                Image(systemName: "clock")
                            }
                            
                            Label {
                                Text(verbatim: event.room.shortName)
                            } icon: {
                                Image(systemName: "mappin.circle")
                            }
                            
                            EventHostsLabel(event)
                        }
                    }
                }
                
                Spacer()
            }
            .listRowInsets(EdgeInsets())
            .background(Color.formHeading)
        }
        
        @ViewBuilder private var inputControls: some View {
            Section {
                HStack {
                    Spacer()
                    
                    StarRating(
                        rating: eventRatingBinding,
                        minRating: Event.Rating.smallestPossibleRatingValue,
                        maxRating: Event.Rating.largestPossibleRatingValue
                    )
                    .frame(maxHeight: 44)
                    
                    Spacer()
                }
                .background(Color.formHeading)
                .listRowInsets(EdgeInsets())
            } header: {
                Text("Rating")
            }
            
            Section {
                TextField("Anything else you would like us to know", text: $feedback.additionalComments)
            } header: {
                Text("Additional Comments")
            } footer: {
                Text("Your feedback will be submitted anonymously. Any comments will be manually reviewed and may be forwarded to the hosts or panelists. Hateful language or insults will not be forwarded.")
            }
        }
        
        private var eventRatingBinding: Binding<Int> {
            Binding(
                get: { feedback.rating.value },
                set: { newValue in feedback.rating.value = newValue }
            )
        }
        
    }
    
}

struct EventFeedbackForm_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { model in
            let dealersDen = model.event(for: .dealersDen)
            let dealersDenFeedback = successfulFeedback(for: dealersDen, in: model)
            EventFeedbackForm(event: dealersDen, feedback: dealersDenFeedback)
                .previewDisplayName("Succeeds Sending Feedback")
            
            let unsuccessfulFeedback = unsuccessfulFeedback(for: dealersDen, in: model)
            EventFeedbackForm(event: dealersDen, feedback: unsuccessfulFeedback)
                .previewDisplayName("Fails Sending Feedback")
        }
    }
    
    private static func successfulFeedback(for event: Event, in model: EurofurenceModel) -> Event.FeedbackForm {
        do {
            let feedback = try event.prepareFeedback()
            model.prepareSuccessfulFeedbackResponse(
                event: event,
                rating: 3,
                comments: "Successful Feedback"
            )
            
            return feedback
        } catch {
            fatalError("Previewing event does not support feedback. Event=\(event)")
        }
    }
    
    private static func unsuccessfulFeedback(for event: Event, in model: EurofurenceModel) -> Event.FeedbackForm {
        do {
            let feedback = try event.prepareFeedback()
            model.prepareUnsuccessfulFeedbackResponse(
                event: event,
                rating: 3,
                comments: "Unsuccessful Feedback"
            )
            
            return feedback
        } catch {
            fatalError("Previewing event does not support feedback. Event=\(event)")
        }
    }
    
}
