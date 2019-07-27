import EurofurenceModel
import XCTest

class WhenObservingRunningEventsAfterSuccessfulLoad: XCTestCase {

    func testEventsThatAreCurrentlyRunningAreProvidedToTheObserver() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime
        let context = EurofurenceSessionTestBuilder().with(simulatedTime).build()
        context.performSuccessfulSync(response: syncResponse)

        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)

        let expectedEvents = syncResponse.events.changed.filter { (event) -> Bool in
            return simulatedTime >= event.startDateTime && simulatedTime < event.endDateTime
        }

        EventAssertion(context: context, modelCharacteristics: syncResponse)
            .assertEvents(observer.runningEvents, characterisedBy: expectedEvents)
    }

    func testEventsThatHaveNotStartedAreNotProvidedToTheObserver() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime.addingTimeInterval(-1)
        let context = EurofurenceSessionTestBuilder().with(simulatedTime).build()
        context.performSuccessfulSync(response: syncResponse)

        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)

        XCTAssertFalse(observer.runningEvents.contains(where: { $0.identifier.rawValue == randomEvent.identifier }),
                       "Simulated Time: \(simulatedTime)\nDid Not Expect: \(randomEvent)")
    }

}
