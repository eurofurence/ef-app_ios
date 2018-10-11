//
//  WhenAddingAnnouncementsObserverAfterSuccessfulRefresh.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenAddingAnnouncementsObserverAfterSuccessfulRefresh: XCTestCase {

    func testTheObserverIsProvidedWithAllAnnouncements() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let expected = context.expectedAnnouncements(from: syncResponse)

        context.performSuccessfulSync(response: syncResponse)
        let observer = CapturingAnnouncementsServiceObserver()
        context.application.add(observer)

        XCTAssertEqual(expected, observer.allAnnouncements)
    }

}
