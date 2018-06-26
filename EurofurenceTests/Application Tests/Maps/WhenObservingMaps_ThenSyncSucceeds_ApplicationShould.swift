//
//  WhenObservingMaps_ThenSyncSucceeds_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenObservingMaps_ThenSyncSucceeds_ApplicationShould: XCTestCase {
    
    func testProvideTheMapsToTheObserverInAlphabeticalOrder() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let observer = CapturingMapsObserver()
        context.application.add(observer)
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let expected = context.makeExpectedMaps(from: syncResponse)
        
        XCTAssertEqual(expected, observer.capturedMaps)
    }
    
}
