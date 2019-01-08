//
//  WhenToldToOpenNotification_ThatRepresentsAnnouncement_ThatHasBeenDeleted_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenToldToOpenNotification_ThatRepresentsAnnouncement_ThatHasBeenDeleted_ApplicationShould: XCTestCase {

    func testProvideTheInvalidatedAnnouncementResponse() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        let randomAnnouncement = syncResponse.announcements.changed.randomElement().element
        let context = ApplicationTestBuilder().build()
        let payload: [String: String] = ["event": "announcement", "announcement_id": randomAnnouncement.identifier]
        var result: NotificationContent?
        context.notificationsService.handleNotification(payload: payload) { result = $0 }
        syncResponse.announcements.changed = []
        syncResponse.announcements.deleted = [randomAnnouncement.identifier]
        context.syncAPI.simulateSuccessfulSync(syncResponse)

        let expected = NotificationContent.invalidatedAnnouncement
        XCTAssertEqual(expected, result)
    }

}
