import EurofurenceModel
import XCTest

class WhenObservingMaps_ThenSyncSucceeds_ApplicationShould: XCTestCase {

    func testProvideTheMapsToTheObserverInAlphabeticalOrder() {
        let context = EurofurenceSessionTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let observer = CapturingMapsObserver()
        context.mapsService.add(observer)
        context.performSuccessfulSync(response: syncResponse)

        MapEntityAssertion().assertMaps(observer.capturedMaps,
                                        characterisedBy: syncResponse.maps.changed)
    }

}
