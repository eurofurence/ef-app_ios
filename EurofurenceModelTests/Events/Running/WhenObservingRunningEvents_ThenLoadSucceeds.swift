import EurofurenceModel
import XCTest

class WhenObservingRunningEvents_ThenLoadSucceeds: XCTestCase {

    func testTheObserverIsProvidedWithTheRunningEvents() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime
        let context = EurofurenceSessionTestBuilder().with(simulatedTime).build()
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)
        context.performSuccessfulSync(response: syncResponse)

        EventAssertion(context: context, modelCharacteristics: syncResponse)
            .assertCollection(observer.runningEvents, containsEventCharacterisedBy: randomEvent)
    }

}
