import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenDataStoreAlreadyContainsMaps_ApplicationShould: XCTestCase {

    func testProvideTheMapsToTheObserverInAlphabeticalOrder() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let dataStore = FakeDataStore(response: syncResponse)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let observer = CapturingMapsObserver()
        context.mapsService.add(observer)

        MapEntityAssertion().assertMaps(observer.capturedMaps,
                                        characterisedBy: syncResponse.maps.changed)
    }

}
