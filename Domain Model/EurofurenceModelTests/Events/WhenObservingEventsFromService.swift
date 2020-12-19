import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenObservingEventsFromService: XCTestCase {

    func testTheObserverShouldNotBeStronglyRetained() {
        let context = EurofurenceSessionTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        var observer: CapturingEventsServiceObserver? = CapturingEventsServiceObserver()
        context.eventsService.add(observer!)
        weak var weakObserver = observer
        observer = nil
        context.performSuccessfulSync(response: syncResponse)
        
        XCTAssertNil(weakObserver)
    }

}
