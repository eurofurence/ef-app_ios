import EurofurenceModel
import XCTest

class InOrderToSupportEssentialSubtitleTag_ApplicationShould: XCTestCase {

    func testCombineSubtitleWithTitle() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement()
        var event = randomEvent.element
        event.tags = ["essential_subtitle"]
        syncResponse.events.changed = [event]
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let eventsObserver = CapturingScheduleRepositoryObserver()
        context.eventsService.add(eventsObserver)
        let observedEvent = eventsObserver.allEvents.first
        let expected = "\(event.title) - \(event.subtitle)"

        XCTAssertEqual(expected, observedEvent?.title)
    }

}
