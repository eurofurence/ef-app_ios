//
//  WhenAddingAnnouncementsObserverAfterSuccessfulRefresh.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenAddingAnnouncementsObserverAfterSuccessfulRefresh: XCTestCase {

    func testTheObserverIsProvidedWithAllAnnouncements() {
        let context = EurofurenceSessionTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions

        context.performSuccessfulSync(response: syncResponse)
        let observer = CapturingAnnouncementsServiceObserver()
        context.announcementsService.add(observer)

        AnnouncementAssertion().assertOrderedAnnouncements(observer.allAnnouncements,
                                                           characterisedBy: syncResponse.announcements.changed)
    }

}
