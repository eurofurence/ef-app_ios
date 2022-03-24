import EurofurenceModel
import XCTest

class InOrderToSupportPhotoshootTag_ApplicationShould: XCTestCase {

    func testIndicateItIsPhotoshootEventWhenTagPresent() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement()
        var event = randomEvent.element
        event.tags = ["photoshoot"]
        syncResponse.events.changed = [event]
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let eventsObserver = CapturingScheduleRepositoryObserver()
        context.eventsService.add(eventsObserver)
        let observedEvent = eventsObserver.allEvents.first

        XCTAssertEqual(true, observedEvent?.isPhotoshoot)
    }

    func testNotIndicateItIsPhotoshootEventWhenTagNotPresent() {
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

        XCTAssertEqual(false, observedEvent?.isPhotoshoot)
    }

}
