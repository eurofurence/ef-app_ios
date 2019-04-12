import EurofurenceModel
import XCTest

class WhenObservingMaps_AfterSyncSucceeds_ApplicationShould: XCTestCase {

    func testProvideTheMapsToTheObserverInAlphabeticalOrder() {
        let context = EurofurenceSessionTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        context.performSuccessfulSync(response: syncResponse)
        let observer = CapturingMapsObserver()
        context.mapsService.add(observer)

        MapEntityAssertion().assertMaps(observer.capturedMaps,
                                        characterisedBy: syncResponse.maps.changed)
    }

}
