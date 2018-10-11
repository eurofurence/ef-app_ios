//
//  AnnouncementRemoveAllBeforeInsertTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class AnnouncementRemoveAllBeforeInsertTests: XCTestCase {

    func testShouldRemoveAllAnnouncementsWhenToldTo() {
        let originalResponse = APISyncResponse.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.announcements.removeAllBeforeInsert = true
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)
        let expected = context.expectedAnnouncements(from: subsequentResponse)
        let observer = CapturingAnnouncementsServiceObserver()
        context.application.add(observer)

        XCTAssertEqual(expected, observer.allAnnouncements,
                       "Should have removed original announcements between sync events")
    }

    func testShouldNotRemoveAllAnnouncementsWhenNotToldToRemoveThem() {
        let originalResponse = APISyncResponse.randomWithoutDeletions
        var subsequentResponse = APISyncResponse.randomWithoutDeletions
        subsequentResponse.announcements.removeAllBeforeInsert = false
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)
        let first = context.expectedAnnouncements(from: originalResponse)
        let second = context.expectedAnnouncements(from: subsequentResponse)
        let expected = first + second
        let observer = CapturingAnnouncementsServiceObserver()
        context.application.add(observer)

        XCTAssertTrue(expected.equalsIgnoringOrder(observer.allAnnouncements),
                      "Should have not removed original announcements between sync events")
    }

}
