//
//  WhenRequestingImageForAnnouncementThatHasNoImage_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 10/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenRequestingImageForAnnouncementThatHasNoImage_ApplicationShould: XCTestCase {

    func testInvokeTheHandlerWithNilData() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomAnnouncement = syncResponse.announcements.changed.randomElement()
        var announcement = randomAnnouncement.element
        announcement.imageIdentifier = nil
        syncResponse.announcements.changed[randomAnnouncement.index] = announcement
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let identifier = AnnouncementIdentifier(announcement.identifier)
        var invokedHandlerWithNilData = false
        let entity = context.announcementsService.fetchAnnouncement(identifier: identifier)
        entity?.fetchAnnouncementImagePNGData(completionHandler: { invokedHandlerWithNilData = $0 == nil })

        XCTAssertTrue(invokedHandlerWithNilData)
    }

}
