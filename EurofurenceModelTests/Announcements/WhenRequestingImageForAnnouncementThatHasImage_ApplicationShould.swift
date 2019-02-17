//
//  WhenRequestingImageForAnnouncementThatHasImage_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 10/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenRequestingImageForAnnouncementThatHasImage_ApplicationShould: XCTestCase {

    func testProvideTheImageData() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let announcement = syncResponse.announcements.changed.randomElement().element
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let expected = context.api.stubbedImage(for: announcement.imageIdentifier)
        let identifier = AnnouncementIdentifier(announcement.identifier)
        var actual: Data?
        context.announcementsService.fetchAnnouncementImage(identifier: identifier) { actual = $0 }

        XCTAssertEqual(expected, actual)
    }

}
