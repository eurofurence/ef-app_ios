import EurofurenceModel
import XCTest

class InOrderToSupportSuperSponsorTag_ApplicationShould: XCTestCase {

    func testIndicateItIsSuperSponsorEventWhenTagPresent() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement()
        var event = randomEvent.element
        event.tags = ["supersponsors_only"]
        syncResponse.events.changed = [event]
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let eventsObserver = CapturingScheduleRepositoryObserver()
        context.eventsService.add(eventsObserver)
        let observedEvent = eventsObserver.allEvents.first

        XCTAssertEqual(true, observedEvent?.isSuperSponsorOnly)
    }

    func testNotIndicateItIsSponsorEventWhenTagotPresent() {
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

        XCTAssertEqual(false, observedEvent?.isSuperSponsorOnly)
    }

}
