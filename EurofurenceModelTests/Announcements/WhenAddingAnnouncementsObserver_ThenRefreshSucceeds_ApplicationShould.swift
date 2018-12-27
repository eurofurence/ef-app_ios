//
//  WhenAddingAnnouncementsObserver_ThenRefreshSucceeds_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenAddingAnnouncementsObserver_ThenRefreshSucceeds_ApplicationShould: XCTestCase {

    func testProvideTheObserverWithAllTheAnnouncements() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let expected = context.expectedAnnouncements(from: syncResponse)

        let observer = CapturingAnnouncementsServiceObserver()
        context.application.add(observer)
        context.performSuccessfulSync(response: syncResponse)

        XCTAssertEqual(expected, observer.allAnnouncements)
    }

}
