import EurofurenceModel
import XCTest

class WhenSyncCompletesWithEvents_ApplicationShould: XCTestCase {

    func testTellObserversAboutAvailableEvents() {
        let context = EurofurenceSessionTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)
        context.performSuccessfulSync(response: syncResponse)

        EventAssertion(context: context, modelCharacteristics: syncResponse)
            .assertEvents(observer.allEvents, characterisedBy: syncResponse.events.changed)
    }

}
