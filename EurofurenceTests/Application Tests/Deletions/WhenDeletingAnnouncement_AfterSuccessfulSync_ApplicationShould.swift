//
//  WhenDeletingAnnouncement_AfterSuccessfulSync_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenDeletingAnnouncement_AfterSuccessfulSync_ApplicationShould: XCTestCase {
    
    func testUpdateDelegateWithoutDeletedAnnouncement() {
        var response = APISyncResponse.randomWithoutDeletions
        let context = ApplicationTestBuilder().build()
        let delegate = CapturingAnnouncementsServiceObserver()
        context.application.add(delegate)
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(response)
        let announcementToDelete = response.announcements.changed.randomElement()
        response.announcements.changed = response.announcements.changed.filter({ $0.identifier != announcementToDelete.element.identifier })
        response.announcements.changed.removeAll()
        response.announcements.deleted.append(announcementToDelete.element.identifier)
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(response)
        let actual = delegate.allAnnouncements.map({ $0.identifier.rawValue })
        
        XCTAssertFalse(actual.contains(announcementToDelete.element.identifier),
                       "Should have removed announcement \(announcementToDelete.element.identifier)")
    }
    
}
