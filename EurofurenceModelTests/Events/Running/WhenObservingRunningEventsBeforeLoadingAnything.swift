import EurofurenceModel
import XCTest

class WhenObservingRunningEventsBeforeLoadingAnything: XCTestCase {

    func testTheObserverIsProvidedWithEmptyEvents() {
        let context = EurofurenceSessionTestBuilder().build()
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)

        XCTAssertTrue(observer.wasProvidedWithEmptyRunningEvents)
    }

}
