@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class ApplicationPreloadingServiceTests: XCTestCase {

    var app: CapturingRefreshService!
    var interactor: ApplicationPreloadInteractor!
    var delegate: CapturingPreloadInteractorDelegate!

    override func setUp() {
        super.setUp()

        app = CapturingRefreshService()
        interactor = ApplicationPreloadInteractor(refreshService: app)
        delegate = CapturingPreloadInteractorDelegate()
    }

    private func beginPreload() {
        interactor.beginPreloading(delegate: delegate)
    }

    private func simulateRefreshFailure() {
        app.failLastRefresh()
    }

    private func simulateRefreshSuccess() {
        app.succeedLastRefresh()
    }

    func testFailedRefreshTellDelegatePreloadServiceFailed() {
        beginPreload()
        simulateRefreshFailure()

        XCTAssertTrue(delegate.wasToldpreloadInteractorDidFailToPreload)
    }

    func testSuccessfulRefreshesDoNotTellDelegatePreloadServiceSucceeded() {
        beginPreload()
        simulateRefreshSuccess()

        XCTAssertFalse(delegate.wasToldpreloadInteractorDidFailToPreload)
    }

    func testSuccessfulRefreshTellsDelegatePreloadServiceSucceeded() {
        beginPreload()
        simulateRefreshSuccess()

        XCTAssertTrue(delegate.wasToldpreloadInteractorDidFinishPreloading)
    }

    func testFailedRefreshDoesNotTellDelegatePreloadServiceSucceeded() {
        beginPreload()
        simulateRefreshFailure()

        XCTAssertFalse(delegate.wasToldpreloadInteractorDidFinishPreloading)
    }

    func testProgressUpdatesFromTheRefreshAreEmittedToTheDelegate() {
        beginPreload()
        let currentUnitCount = Int.random
        let totalUnitCount = currentUnitCount + 1
        app.updateProgressForCurrentRefresh(currentUnitCount: currentUnitCount, totalUnitCount: totalUnitCount)

        XCTAssertEqual(currentUnitCount, delegate.capturedProgressCurrentUnitCount)
        XCTAssertEqual(totalUnitCount, delegate.capturedProgressTotalUnitCount)
        XCTAssertNotNil(delegate.capturedProgressLocalizedDescription)
    }

}
