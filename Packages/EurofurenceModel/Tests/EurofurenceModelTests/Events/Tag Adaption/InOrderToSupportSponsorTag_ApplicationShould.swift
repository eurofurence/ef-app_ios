import EurofurenceModel
import XCTest

class InOrderToSupportSponsorTag_ApplicationShould: XCTestCase {

    func testIndicateItIsSponsorEventWhenTagPresent() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement()
        var event = randomEvent.element
        event.tags = ["sponsors_only"]
        syncResponse.events.changed = [event]
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let eventsObserver = CapturingScheduleRepositoryObserver()
        context.eventsService.add(eventsObserver)
        let observedEvent = eventsObserver.allEvents.first

        XCTAssertEqual(true, observedEvent?.isSponsorOnly)
    }

    func testNotIndicateItIsSponsorEventWhenTagNotPresent() {
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

        XCTAssertEqual(false, observedEvent?.isSponsorOnly)
    }

}
