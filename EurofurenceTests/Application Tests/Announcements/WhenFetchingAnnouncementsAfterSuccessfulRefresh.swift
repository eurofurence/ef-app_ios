//
//  WhenFetchingAnnouncementsAfterSuccessfulRefresh.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingAnnouncementsServiceObserver: AnnouncementsServiceObserver {
    
    private(set) var unreadAnnouncements: [Announcement2] = []
    private(set) var didReceieveEmptyUnreadAnnouncements = false
    func eurofurenceApplicationDidChangeUnreadAnnouncements(to announcements: [Announcement2]) {
        unreadAnnouncements = announcements
        didReceieveEmptyUnreadAnnouncements = didReceieveEmptyUnreadAnnouncements || announcements.isEmpty
    }
    
}

class WhenFetchingAnnouncementsAfterSuccessfulRefresh: XCTestCase {
    
    func testTheAnnouncementsFromTheRefreshResponseAreAdaptedInLastChangedTimeOrder() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let expectedOrder = syncResponse.announcements.changed.sorted { (first, second) -> Bool in
            return first.lastChangedDateTime.compare(second.lastChangedDateTime) == .orderedAscending
        }
        
        let expected = Announcement2.fromServerModels(expectedOrder)
        
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let observer = CapturingAnnouncementsServiceObserver()
        context.application.add(observer)
        
        XCTAssertEqual(expected, observer.unreadAnnouncements)
    }
    
}
