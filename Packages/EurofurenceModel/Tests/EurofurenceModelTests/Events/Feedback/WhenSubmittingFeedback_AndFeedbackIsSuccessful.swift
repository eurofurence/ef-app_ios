import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenSubmittingFeedback_AndFeedbackIsSuccessful: XCTestCase {

    func testTheDelegateIsToldTheFeedbackSucceeded() {
        var characteristics = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = characteristics.events.changed.randomElement()
        var event = randomEvent.element
        event.isAcceptingFeedback = true
        characteristics.events.changed[randomEvent.index] = event
        let store = InMemoryDataStore(response: characteristics)
        let context = EurofurenceSessionTestBuilder().with(store).build()
        let schedule = context.services.events.makeEventsSchedule()
        let entity = schedule.fetchEvent(identifier: EventIdentifier(event.identifier))
        let delegate = CapturingEventFeedbackDelegate()
        let feedback = entity?.prepareFeedback()
        feedback?.starRating = 5
        feedback?.feedback = "Feedback"
        feedback?.submit(delegate)
        let feedbackRequest = EventFeedbackRequest(id: event.identifier, rating: 5, feedback: "Feedback")
        context.api.simulateSuccessfulFeedbackResponse(for: feedbackRequest)
        
        XCTAssertEqual(delegate.feedbackState, .success)
    }
    
    func testTheDefaultFeedbackValueShouldBeUsed() {
        var characteristics = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = characteristics.events.changed.randomElement()
        var event = randomEvent.element
        event.isAcceptingFeedback = true
        characteristics.events.changed[randomEvent.index] = event
        let store = InMemoryDataStore(response: characteristics)
        let context = EurofurenceSessionTestBuilder().with(store).build()
        let schedule = context.services.events.makeEventsSchedule()
        let entity = schedule.fetchEvent(identifier: EventIdentifier(event.identifier))
        let delegate = CapturingEventFeedbackDelegate()
        let feedback = entity?.prepareFeedback()
        feedback?.submit(delegate)
        
        let defaultEventFeedbackValue = 3
        let feedbackRequest = EventFeedbackRequest(
            id: event.identifier,
            rating: defaultEventFeedbackValue,
            feedback: ""
        )
        
        context.api.simulateSuccessfulFeedbackResponse(for: feedbackRequest)
        
        XCTAssertEqual(delegate.feedbackState, .success)
    }

}
