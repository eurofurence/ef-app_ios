import EurofurenceModel
import XCTest

class WhenObservingUpcomingEventsBeforeLoadingAnything: XCTestCase {

    func testTheObserverIsProvidedWithEmptyUpcomingEvents() {
        let context = EurofurenceSessionTestBuilder().build()
        let observer = CapturingScheduleRepositoryObserver()
        context.eventsService.add(observer)

        XCTAssertTrue(observer.wasProvidedWithEmptyUpcomingEvents)
    }

}
