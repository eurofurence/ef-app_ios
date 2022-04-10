import Combine
import EurofurenceApplication
import ObservedObject
import RouterCore
import XCTest
import XCTRouter

class ConventionCountdownViewModelTests: XCTestCase {
    
    func testOneDayUntilConvention() {
        let dataSource = ControllableConventionCountdownDataSource()
        dataSource.simulateCountdownState(.countingDown(days: 1))
        let viewModelFactory = ConventionCountdownViewModelFactory(dataSource: dataSource)
        let router = FakeContentRouter()
        let viewModel = viewModelFactory.makeViewModel(router: router)
        
        XCTAssertTrue(viewModel.showCountdown)
        XCTAssertEqual("1 day remaining", viewModel.countdownDescription)
    }
    
    func testMultipleDaysUntilConvention() {
        let dataSource = ControllableConventionCountdownDataSource()
        dataSource.simulateCountdownState(.countingDown(days: 2))
        let viewModelFactory = ConventionCountdownViewModelFactory(dataSource: dataSource)
        let router = FakeContentRouter()
        let viewModel = viewModelFactory.makeViewModel(router: router)
        
        XCTAssertTrue(viewModel.showCountdown)
        XCTAssertEqual("2 days remaining", viewModel.countdownDescription)
    }
    
    func testCountdownElapsed() {
        let dataSource = ControllableConventionCountdownDataSource()
        dataSource.simulateCountdownState(.elapsed)
        let viewModelFactory = ConventionCountdownViewModelFactory(dataSource: dataSource)
        let router = FakeContentRouter()
        let viewModel = viewModelFactory.makeViewModel(router: router)
        
        XCTAssertFalse(viewModel.showCountdown)
        XCTAssertNil(viewModel.countdownDescription)
    }
    
    func testTransitioningFromOneDayUntilCountdownElapsed() {
        let dataSource = ControllableConventionCountdownDataSource()
        dataSource.simulateCountdownState(.countingDown(days: 1))
        let viewModelFactory = ConventionCountdownViewModelFactory(dataSource: dataSource)
        let router = FakeContentRouter()
        let viewModel = viewModelFactory.makeViewModel(router: router)
        dataSource.simulateCountdownState(.elapsed)
        
        XCTAssertFalse(viewModel.showCountdown)
        XCTAssertNil(viewModel.countdownDescription)
    }
    
    func testTransitioningFromCountdownElapsedToNextConCountdown() {
        let dataSource = ControllableConventionCountdownDataSource()
        dataSource.simulateCountdownState(.elapsed)
        let viewModelFactory = ConventionCountdownViewModelFactory(dataSource: dataSource)
        let router = FakeContentRouter()
        let viewModel = viewModelFactory.makeViewModel(router: router)
        dataSource.simulateCountdownState(.countingDown(days: 330))
        
        XCTAssertTrue(viewModel.showCountdown)
        XCTAssertEqual("330 days remaining", viewModel.countdownDescription)
    }
    
    private class ControllableConventionCountdownDataSource: ConventionCountdownDataSource {
        
        let state = CurrentValueSubject<ConventionCountdown, Never>(.elapsed)
        
        func simulateCountdownState(_ state: ConventionCountdown) {
            self.state.value = state
        }
        
    }
    
}
