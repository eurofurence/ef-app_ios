import EurofurenceModel
import XCTest

class WhenObservingConventionCountdown_AndSignificantTimeChangeOccurs_EurofurenceApplicationShould: XCTestCase {

    func testUpdateTheObserversWithTheNewCountdownInterval() {
        let observer = CapturingConventionCountdownServiceObserver()
        let clockTime = Date.random
        let context = EurofurenceSessionTestBuilder().with(clockTime).build()
        var expected: Int = .random
        context.dateDistanceCalculator.stubDistance(between: clockTime, and: context.conventionStartDateRepository.conventionStartDate, with: expected)
        context.conventionCountdownService.add(observer)
        expected = .random
        context.dateDistanceCalculator.stubDistance(between: clockTime, and: context.conventionStartDateRepository.conventionStartDate, with: expected)
        context.significantTimeChangeAdapter.simulateSignificantTimeChange()

        XCTAssertEqual(expected, observer.capturedDaysRemaining)
    }

}
