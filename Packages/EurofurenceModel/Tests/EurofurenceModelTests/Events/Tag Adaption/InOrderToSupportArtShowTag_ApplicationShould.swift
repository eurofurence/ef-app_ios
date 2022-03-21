import EurofurenceModel
import XCTest

class InOrderToSupportArtShowTag_ApplicationShould: XCTestCase {

    func testIndicateItIsArtShowEventWhenTagPresent() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement()
        var event = randomEvent.element
        event.tags = ["art_show"]
        syncResponse.events.changed = [event]
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let eventsObserver = CapturingScheduleRepositoryObserver()
        context.eventsService.add(eventsObserver)
        let observedEvent = eventsObserver.allEvents.first

        XCTAssertEqual(true, observedEvent?.isArtShow)
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

        XCTAssertEqual(false, observedEvent?.isArtShow)
    }

}
