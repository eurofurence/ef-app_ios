import EurofurenceModel
import XCTest

class WhenObservingCountdownUntilConvention_EurofurenceApplicationShould: XCTestCase {

    func testOneDayToGo() {
        let observer = CapturingConventionCountdownServiceObserver()
        let clockTime = Date()
        let conventionStartDateRepository = StubConventionStartDateRepository()
        conventionStartDateRepository.conventionStartDate = clockTime.addingTimeInterval(60 * 60 * 24)
        let context = EurofurenceSessionTestBuilder().with(clockTime).with(conventionStartDateRepository).build()
        context.conventionCountdownService.add(observer)

        XCTAssertEqual(1, observer.capturedDaysRemaining)
    }
    
    func testTwoDaysToGo() {
        let observer = CapturingConventionCountdownServiceObserver()
        let clockTime = Date()
        let conventionStartDateRepository = StubConventionStartDateRepository()
        conventionStartDateRepository.conventionStartDate = clockTime.addingTimeInterval((60 * 60 * 24) * 2)
        let context = EurofurenceSessionTestBuilder().with(clockTime).with(conventionStartDateRepository).build()
        context.conventionCountdownService.add(observer)
        
        XCTAssertEqual(2, observer.capturedDaysRemaining)
    }

}
