import EurofurenceModel
import XCTest

class WhenObservingConventionCountdownAfterConventionStarts_EurofurenceApplicationShould: XCTestCase {

    func testTellObserverTheCountdownElapsed() {
        let observer = CapturingConventionCountdownServiceObserver()
        let clockTime = Date.random
        let context = EurofurenceSessionTestBuilder().with(clockTime).build()
        let distanceToImplyConventionHasStarted = 0
        context.dateDistanceCalculator.stubDistance(between: clockTime,
                                                    and: context.conventionStartDateRepository.conventionStartDate,
                                                    with: distanceToImplyConventionHasStarted)
        context.conventionCountdownService.add(observer)

        XCTAssertTrue(observer.toldCountdownDidElapse)
    }

}
