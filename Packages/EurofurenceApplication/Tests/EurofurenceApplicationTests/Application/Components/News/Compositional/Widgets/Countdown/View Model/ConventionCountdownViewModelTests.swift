import Combine
import EurofurenceApplication
import ObservedObject
import RouterCore
import XCTest
import XCTRouter

class ConventionCountdownViewModelTests: XCTestCase {
    
    private var dataSource: ControllableConventionCountdownDataSource!
    private var router: FakeContentRouter!
    private var viewModel: DataSourceBackedConventionCountdownViewModel!
    
    override func setUp() {
        super.setUp()
        
        dataSource = ControllableConventionCountdownDataSource()
        let viewModelFactory = ConventionCountdownViewModelFactory(dataSource: dataSource)
        router = FakeContentRouter()
        viewModel = viewModelFactory.makeViewModel(router: router)
    }
    
    func testOneDayUntilConvention() {
        dataSource.simulateCountdownState(.countingDown(days: 1))
        
        XCTAssertTrue(viewModel.showCountdown)
        XCTAssertEqual("1 day remaining", viewModel.countdownDescription)
    }
    
    func testMultipleDaysUntilConvention() {
        dataSource.simulateCountdownState(.countingDown(days: 2))
        
        XCTAssertTrue(viewModel.showCountdown)
        XCTAssertEqual("2 days remaining", viewModel.countdownDescription)
    }
    
    func testCountdownElapsed() {
        dataSource.simulateCountdownState(.elapsed)
        
        XCTAssertFalse(viewModel.showCountdown)
        XCTAssertNil(viewModel.countdownDescription)
    }
    
    func testTransitioningFromOneDayUntilCountdownElapsed() {
        dataSource.simulateCountdownState(.countingDown(days: 1))
        dataSource.simulateCountdownState(.elapsed)
        
        XCTAssertFalse(viewModel.showCountdown)
        XCTAssertNil(viewModel.countdownDescription)
    }
    
    func testTransitioningFromCountdownElapsedToNextConCountdown() {
        dataSource.simulateCountdownState(.elapsed)
        dataSource.simulateCountdownState(.countingDown(days: 330))
        
        XCTAssertTrue(viewModel.showCountdown)
        XCTAssertEqual("330 days remaining", viewModel.countdownDescription)
    }
    
    func testShowCountdownAndDescriptionSendObjectDidChangeUpdates() {
        let showCountdown = viewModel.publisher(for: \.showCountdown, options: [])
        let coundownDescription = viewModel.publisher(for: \.countdownDescription, options: [])
        
        var objectChangedSent = false
        let subscription = showCountdown
            .combineLatest(coundownDescription)
            .sink { (_, _) in
                objectChangedSent = true
            }
        
        defer {
            subscription.cancel()
        }
        
        dataSource.simulateCountdownState(.countingDown(days: 1))
        
        XCTAssertTrue(objectChangedSent)
    }
    
    private class ControllableConventionCountdownDataSource: ConventionCountdownDataSource {
        
        let state = CurrentValueSubject<ConventionCountdown, Never>(.elapsed)
        
        func simulateCountdownState(_ state: ConventionCountdown) {
            self.state.value = state
        }
        
    }
    
}
