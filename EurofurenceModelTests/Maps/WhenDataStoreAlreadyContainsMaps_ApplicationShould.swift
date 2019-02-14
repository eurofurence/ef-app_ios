//
//  WhenDataStoreAlreadyContainsMaps_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenDataStoreAlreadyContainsMaps_ApplicationShould: XCTestCase {

    func testProvideTheMapsToTheObserverInAlphabeticalOrder() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(syncResponse)
        let context = ApplicationTestBuilder().with(dataStore).build()
        let observer = CapturingMapsObserver()
        context.mapsService.add(observer)

        MapEntityAssertion().assertMaps(observer.capturedMaps,
                                        characterisedBy: syncResponse.maps.changed)
    }

}
