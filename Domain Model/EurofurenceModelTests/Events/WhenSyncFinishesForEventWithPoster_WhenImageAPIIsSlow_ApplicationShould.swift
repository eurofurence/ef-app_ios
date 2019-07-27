import EurofurenceModel
import XCTest

class WhenSyncFinishesForEventWithPoster_WhenImageAPIIsSlow_ApplicationShould: XCTestCase {

    func testStillAdaptTheFetchedDataIntoTheEvent() {
        let imageAPI = SlowFakeImageAPI()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime
        let context = EurofurenceSessionTestBuilder().with(imageAPI).with(simulatedTime).build()
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)
        context.performSuccessfulSync(response: syncResponse)
        imageAPI.resolvePendingFetches()

        EventAssertion(context: context, modelCharacteristics: syncResponse)
            .assertCollection(observer.runningEvents, containsEventCharacterisedBy: randomEvent)
    }

}
