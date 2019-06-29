import EurofurenceModel
import XCTest

class WhenObservingConventionCountdownAfterConventionStarts_EurofurenceApplicationShould: XCTestCase {

    func testTellObserverTheCountdownElapsed() {
        let observer = CapturingConventionCountdownServiceObserver()
        let clockTime = Date.random
        let conventionStartDateRepository = StubConventionStartDateRepository()
        conventionStartDateRepository.conventionStartDate = clockTime.addingTimeInterval(-(60 * 60 * 24))
        let context = EurofurenceSessionTestBuilder().with(clockTime).with(conventionStartDateRepository).build()
        context.conventionCountdownService.add(observer)

        XCTAssertTrue(observer.toldCountdownDidElapse)
    }

}
