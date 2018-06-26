//
//  WhenObservingMaps_AfterSyncSucceeds_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingMapsObserver: MapsObserver {
    
    private(set) var capturedMaps: [Map2] = []
    func mapsServiceDidChangeMaps(_ maps: [Map2]) {
        capturedMaps = maps
    }
    
}

class WhenObservingMaps_AfterSyncSucceeds_ApplicationShould: XCTestCase {
    
    func testProvideTheMapsToTheObserverInAlphabeticalOrder() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let expected = context.makeExpectedMaps(from: syncResponse)
        let observer = CapturingMapsObserver()
        context.application.add(observer)
        
        XCTAssertEqual(expected, observer.capturedMaps)
    }
    
}
