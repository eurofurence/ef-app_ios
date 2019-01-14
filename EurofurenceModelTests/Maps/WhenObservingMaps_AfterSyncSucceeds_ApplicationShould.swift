//
//  WhenObservingMaps_AfterSyncSucceeds_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenObservingMaps_AfterSyncSucceeds_ApplicationShould: XCTestCase {

    func testProvideTheMapsToTheObserverInAlphabeticalOrder() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        context.performSuccessfulSync(response: syncResponse)
        let expected = context.makeExpectedMaps(from: syncResponse)
        let observer = CapturingMapsObserver()
        context.mapsService.add(observer)

        XCTAssertEqual(expected, observer.capturedMaps)
    }

}
