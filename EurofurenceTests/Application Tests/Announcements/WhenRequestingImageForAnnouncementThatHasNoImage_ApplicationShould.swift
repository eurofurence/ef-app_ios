//
//  WhenRequestingImageForAnnouncementThatHasNoImage_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 10/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenRequestingImageForAnnouncementThatHasNoImage_ApplicationShould: XCTestCase {
    
    func testInvokeTheHandlerWithNilData() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        let randomAnnouncement = syncResponse.announcements.changed.randomElement()
        var announcement = randomAnnouncement.element
        announcement.imageIdentifier = nil
        syncResponse.announcements.changed[randomAnnouncement.index] = announcement
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let identifier = Announcement2.Identifier(announcement.identifier)
        var invokedHandlerWithNilData = false
        context.application.fetchAnnouncementImage(identifier: identifier) { invokedHandlerWithNilData = $0 == nil }
        
        XCTAssertTrue(invokedHandlerWithNilData)
    }
    
}
