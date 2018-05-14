//
//  WhenAddingAnnouncementsObserverThenRefreshSucceeds.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 14/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenAddingAnnouncementsObserverThenRefreshSucceeds: XCTestCase {
    
    func testTheObserverIsProvidedWithTheAnnouncements() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let expected = context.expectedAnnouncements(from: syncResponse)
        
        let observer = CapturingAnnouncementsServiceObserver()
        context.application.add(observer)
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        
        XCTAssertEqual(expected, observer.unreadAnnouncements)
    }
    
}
