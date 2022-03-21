import EurofurenceModel
import XCTest

class WhenObservingRunningEvents_ThenLoadSucceeds: XCTestCase {

    func testTheObserverIsProvidedWithTheRunningEvents() throws {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime
        let context = EurofurenceSessionTestBuilder().with(simulatedTime).build()
        let observer = CapturingScheduleRepositoryObserver()
        context.eventsService.add(observer)
        context.performSuccessfulSync(response: syncResponse)

        try EventAssertion(context: context, modelCharacteristics: syncResponse)
            .assertCollection(observer.runningEvents, containsEventCharacterisedBy: randomEvent)
    }
    
    func testRunningEventsProvidedInAlphabeticalOrderIgnoringStartTime() {
        let now = Date()
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        var firstEvent = syncResponse.events.changed[0]
        firstEvent.title = "Z"
        firstEvent.startDateTime = now.addingTimeInterval(-1000)
        firstEvent.endDateTime = now.addingTimeInterval(1000)
        var secondEvent = syncResponse.events.changed[1]
        secondEvent.title = "A"
        secondEvent.startDateTime = now.addingTimeInterval(-100)
        secondEvent.endDateTime = now.addingTimeInterval(1000)
        syncResponse.events = .init(changed: [firstEvent, secondEvent], deleted: [], removeAllBeforeInsert: false)
        let context = EurofurenceSessionTestBuilder().with(now).build()
        context.performSuccessfulSync(response: syncResponse)
        let observer = CapturingScheduleRepositoryObserver()
        context.eventsService.add(observer)
        
        let firstRealEvent = observer.runningEvents[0]
        let secondRealEvent = observer.runningEvents[1]
        
        XCTAssertEqual(firstRealEvent.identifier, EventIdentifier(secondEvent.identifier))
        XCTAssertEqual(secondRealEvent.identifier, EventIdentifier(firstEvent.identifier))
    }

}
