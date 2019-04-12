import EurofurenceModel
import XCTest

class WhenObservingUpcomingEventsBeforeLoadingAnything: XCTestCase {

    func testTheObserverIsProvidedWithEmptyUpcomingEvents() {
        let context = EurofurenceSessionTestBuilder().build()
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)

        XCTAssertTrue(observer.wasProvidedWithEmptyUpcomingEvents)
    }

}
