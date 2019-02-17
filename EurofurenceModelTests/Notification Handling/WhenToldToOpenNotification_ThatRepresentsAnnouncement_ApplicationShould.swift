//
//  WhenToldToOpenNotification_ThatRepresentsAnnouncement_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenToldToOpenNotification_ThatRepresentsAnnouncement_ApplicationShould: XCTestCase {

    func testProvideTheAnnouncementToTheCompletionHandler() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomAnnouncement = syncResponse.announcements.changed.randomElement().element
        let context = ApplicationTestBuilder().build()
        let payload: [String: String] = ["event": "announcement", "announcement_id": randomAnnouncement.identifier]
        var result: NotificationContent?
        context.session.services.notifications.handleNotification(payload: payload) { result = $0 }
        context.api.simulateSuccessfulSync(syncResponse)

        let expected = NotificationContent.announcement(AnnouncementIdentifier(randomAnnouncement.identifier))
        XCTAssertEqual(expected, result)
    }

}
