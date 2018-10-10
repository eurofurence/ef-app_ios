//
//  WhenToldToOpenNotification_ThatRepresentsAnnouncement_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenToldToOpenNotification_ThatRepresentsAnnouncement_ApplicationShould: XCTestCase {
    
    func testProvideTheAnnouncementToTheCompletionHandler() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let randomAnnouncement = syncResponse.announcements.changed.randomElement().element
        let context = ApplicationTestBuilder().build()
        let payload: [String : String] = ["event" : "announcement", "announcement_id" : randomAnnouncement.identifier]
        var result: ApplicationPushActionResult?
        context.application.handleRemoteNotification(payload: payload) { result = $0 }
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        
        let expected = ApplicationPushActionResult.announcement(Announcement2.Identifier(randomAnnouncement.identifier))
        XCTAssertEqual(expected, result)
    }
    
}
