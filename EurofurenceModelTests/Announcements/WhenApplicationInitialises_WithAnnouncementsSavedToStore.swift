//
//  WhenApplicationInitialises_WithAnnouncementsSavedToStore.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenApplicationInitialises_WithAnnouncementsSavedToStore: XCTestCase {

    func testTheEventsAreProvidedToTheObserver() {
        let dataStore = CapturingDataStore()
        let announcements = [AnnouncementCharacteristics].random
        dataStore.performTransaction { (transaction) in
            transaction.saveAnnouncements(announcements)
        }

        let context = ApplicationTestBuilder().with(dataStore).build()
        let observer = CapturingAnnouncementsServiceObserver()
        context.announcementsService.add(observer)

        AnnouncementAssertion().assertOrderedAnnouncements(observer.allAnnouncements,
                                                           characterisedBy: announcements)
    }

}
