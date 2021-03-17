import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenDataStoreAlreadyContainsMaps_ApplicationShould: XCTestCase {

    func testProvideTheMapsToTheObserverInAlphabeticalOrder() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let dataStore = InMemoryDataStore(response: syncResponse)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let observer = CapturingMapsObserver()
        context.mapsService.add(observer)

        MapEntityAssertion().assertMaps(observer.capturedMaps,
                                        characterisedBy: syncResponse.maps.changed)
    }

}
