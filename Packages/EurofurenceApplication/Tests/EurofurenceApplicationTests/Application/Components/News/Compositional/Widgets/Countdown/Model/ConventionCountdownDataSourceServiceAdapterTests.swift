import Combine
import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class ConventionCountdownDataSourceServiceAdapterTests: XCTestCase {
    
    func testCountingDown() {
        let countdownService = StubConventionCountdownService()
        let dataSource = ConventionCountdownDataSourceServiceAdapter(countdownService: countdownService)
        countdownService.changeDaysUntilConvention(to: 42)
        
        var observedCountdown: ConventionCountdown?
        let cancellable = dataSource
            .state
            .sink { (countdown) in
                observedCountdown = countdown
            }
        
        defer {
            cancellable.cancel()
        }
        
        XCTAssertEqual(.countingDown(days: 42), observedCountdown)
    }
    
    func testCountdownElapsed() {
        let countdownService = StubConventionCountdownService()
        let dataSource = ConventionCountdownDataSourceServiceAdapter(countdownService: countdownService)
        countdownService.changeDaysUntilConvention(to: 42)
        countdownService.simulateCountdownFinished()
        
        var observedCountdown: ConventionCountdown?
        let cancellable = dataSource
            .state
            .sink { (countdown) in
                observedCountdown = countdown
            }
        
        defer {
            cancellable.cancel()
        }
        
        XCTAssertEqual(.elapsed, observedCountdown)
    }
    
}
