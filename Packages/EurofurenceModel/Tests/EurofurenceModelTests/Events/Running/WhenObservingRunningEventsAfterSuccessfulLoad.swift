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

        let expectedEventIdentifiers = syncResponse.events.changed.filter { (event) -> Bool in
            return simulatedTime >= event.startDateTime && simulatedTime < event.endDateTime
        }.map(\.identifier)
        
        let actualEventIdentifiers = observer.runningEvents.map(\.identifier.rawValue)

        XCTAssertEqual(Set(expectedEventIdentifiers), Set(actualEventIdentifiers))
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
