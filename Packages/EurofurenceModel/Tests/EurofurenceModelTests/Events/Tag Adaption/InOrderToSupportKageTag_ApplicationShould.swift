import EurofurenceModel
import XCTest

class InOrderToSupportKageTag_ApplicationShould: XCTestCase {

    func testIndicateItIsKageEventWhenTagPresent() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement()
        var event = randomEvent.element
        event.tags = ["kage"]
        syncResponse.events.changed = [event]
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let eventsObserver = CapturingScheduleRepositoryObserver()
        context.eventsService.add(eventsObserver)
        let observedEvent = eventsObserver.allEvents.first

        XCTAssertEqual(true, observedEvent?.isKageEvent)
    }

    func testNotIndicateItIsArtShowEventWhenTagNotPresent() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement()
        var event = randomEvent.element
        event.tags = []
        syncResponse.events.changed = [event]
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let eventsObserver = CapturingScheduleRepositoryObserver()
        context.eventsService.add(eventsObserver)
        let observedEvent = eventsObserver.allEvents.first

        XCTAssertEqual(false, observedEvent?.isKageEvent)
    }

}
