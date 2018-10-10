//
//  WhenPreparingAnnouncementViewModel_ForReadAnnouncement_NewsInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import XCTest

class WhenPreparingAnnouncementViewModel_ForReadAnnouncement_NewsInteractorShould: XCTestCase {
    
    func testPrepareViewModelWithReadStatus() {
        let announcement = Announcement2.random
        let announcementsService = StubAnnouncementsService(announcements: [announcement],
                                                            stubbedReadAnnouncements: [announcement.identifier])
        let context = DefaultNewsInteractorTestBuilder().with(announcementsService).build()
        context.subscribeViewModelUpdates()
        
        context
            .assert()
            .thatViewModel()
            .hasYourEurofurence()
            .hasConventionCountdown()
            .hasAnnouncements()
            .verify()
    }
    
}
