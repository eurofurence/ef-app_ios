import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenObservingEventsFromService: XCTestCase {

    func testTheObserverShouldNotBeStronglyRetained() {
        let context = EurofurenceSessionTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        var observer: CapturingScheduleRepositoryObserver? = CapturingScheduleRepositoryObserver()
        context.eventsService.add(observer.unsafelyUnwrapped)
        weak var weakObserver = observer
        observer = nil
        context.performSuccessfulSync(response: syncResponse)
        
        XCTAssertNil(weakObserver)
    }

}
