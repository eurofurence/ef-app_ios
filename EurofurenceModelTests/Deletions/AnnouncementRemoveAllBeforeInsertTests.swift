//
//  AnnouncementRemoveAllBeforeInsertTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class AnnouncementRemoveAllBeforeInsertTests: XCTestCase {

    func testShouldRemoveAllAnnouncementsWhenToldTo() {
        let originalResponse = ModelCharacteristics.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.announcements.removeAllBeforeInsert = true
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)
        let observer = CapturingAnnouncementsServiceObserver()
        context.announcementsService.add(observer)

        AnnouncementAssertion().assertOrderedAnnouncements(observer.allAnnouncements,
                                                           characterisedBy: subsequentResponse.announcements.changed)
    }

    func testShouldNotRemoveAllAnnouncementsWhenNotToldToRemoveThem() {
        let originalResponse = ModelCharacteristics.randomWithoutDeletions
        var subsequentResponse = ModelCharacteristics.randomWithoutDeletions
        subsequentResponse.announcements.removeAllBeforeInsert = false
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)
        let combinedResponses = originalResponse.announcements.changed + subsequentResponse.announcements.changed
        let observer = CapturingAnnouncementsServiceObserver()
        context.announcementsService.add(observer)

        AnnouncementAssertion().assertOrderedAnnouncements(observer.allAnnouncements,
                                                           characterisedBy: combinedResponses)
    }

}
