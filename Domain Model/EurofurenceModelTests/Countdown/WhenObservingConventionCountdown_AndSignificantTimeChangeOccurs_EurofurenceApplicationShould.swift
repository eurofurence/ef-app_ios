import EurofurenceModel
import XCTest

class WhenObservingConventionCountdown_AndSignificantTimeChangeOccurs_EurofurenceApplicationShould: XCTestCase {

    func testUpdateTheObserversWithTheNewCountdownInterval() {
        let observer = CapturingConventionCountdownServiceObserver()
        let clockTime = Date.random
        let conventionStartDateRepository = StubConventionStartDateRepository()
        conventionStartDateRepository.conventionStartDate = clockTime.addingTimeInterval(60 * 60 * 24)
        let context = EurofurenceSessionTestBuilder().with(conventionStartDateRepository).build()
        context.conventionCountdownService.add(observer)
        context.tickTime(to: clockTime)
        context.significantTimeChangeAdapter.simulateSignificantTimeChange()

        XCTAssertEqual(1, observer.capturedDaysRemaining)
    }

}
