//
//  WhenPreparingAnnouncementViewModel_ForReadAnnouncement_NewsInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingAnnouncementViewModel_ForReadAnnouncement_NewsInteractorShould: XCTestCase {

    func testPrepareViewModelWithReadStatus() {
        let announcement = StubAnnouncement.random
        let announcementsService = FakeAnnouncementsService(announcements: [announcement],
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
