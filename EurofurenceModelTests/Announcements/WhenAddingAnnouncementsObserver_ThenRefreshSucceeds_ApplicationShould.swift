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
        let context = EurofurenceSessionTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions

        let observer = CapturingAnnouncementsServiceObserver()
        context.announcementsService.add(observer)
        context.performSuccessfulSync(response: syncResponse)

        AnnouncementAssertion().assertOrderedAnnouncements(observer.allAnnouncements,
                                                           characterisedBy: syncResponse.announcements.changed)
    }

}
