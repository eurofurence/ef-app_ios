//
//  WhenOpeningAnnouncement_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenOpeningAnnouncement_ApplicationShould: XCTestCase {
    
    func testProvideTheAnnouncementToTheCompletionHandler() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let announcements = syncResponse.announcements.changed
        let announcement = announcements.randomElement().element
        let identifier = announcement.identifier
        let context = ApplicationTestBuilder().build()
        let expected = context.expectedAnnouncement(from: announcement)
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        var model: Announcement2?
        context.application.openAnnouncement(identifier: Announcement2.Identifier(identifier)) { model = $0 }
        
        XCTAssertEqual(expected, model)
    }
    
    func testSaveTheAnnouncementIdentifierAsReadAnnouncementToStore() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let announcements = syncResponse.announcements.changed
        let announcement = announcements.randomElement().element
        let identifier = announcement.identifier
        let context = ApplicationTestBuilder().build()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        context.application.openAnnouncement(identifier: Announcement2.Identifier(identifier)) { (_) in }
        
        XCTAssertTrue(context.dataStore.didSaveReadAnnouncement(Announcement2.Identifier(identifier)))
    }
    
    func testSaveAllPreviouslyReadAnnouncementIdentifierAsRead() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let announcements = syncResponse.announcements.changed
        let firstAnnouncement = announcements.randomElement().element
        let firstIdentifier = firstAnnouncement.identifier
        let secondAnnouncement = announcements.randomElement().element
        let secondIdentifier = secondAnnouncement.identifier
        let context = ApplicationTestBuilder().build()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        context.application.openAnnouncement(identifier: Announcement2.Identifier(firstIdentifier)) { (_) in }
        context.application.openAnnouncement(identifier: Announcement2.Identifier(secondIdentifier)) { (_) in }
        let expected = [firstIdentifier, secondIdentifier].map({ Announcement2.Identifier($0) })
        
        XCTAssertTrue(context.dataStore.didSaveReadAnnouncements(expected))
    }
    
    func testTellServiceObserversWhenMarkingAnnouncementAsRead() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let announcements = syncResponse.announcements.changed
        let firstAnnouncement = announcements.randomElement().element
        let firstIdentifier = firstAnnouncement.identifier
        let secondAnnouncement = announcements.randomElement().element
        let secondIdentifier = secondAnnouncement.identifier
        let context = ApplicationTestBuilder().build()
        let observer = CapturingAnnouncementsServiceObserver()
        context.application.add(observer)
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        context.application.openAnnouncement(identifier: Announcement2.Identifier(firstIdentifier)) { (_) in }
        context.application.openAnnouncement(identifier: Announcement2.Identifier(secondIdentifier)) { (_) in }
        let expected = [firstIdentifier, secondIdentifier].map({ Announcement2.Identifier($0) })
        
        XCTAssertTrue(observer.readAnnouncementIdentifiers.contains(elementsFrom: expected))
    }
    
    func testTellLaterAddedObserversAboutMarkedReadAnnouncements() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let announcements = syncResponse.announcements.changed
        let firstAnnouncement = announcements.randomElement().element
        let firstIdentifier = firstAnnouncement.identifier
        let secondAnnouncement = announcements.randomElement().element
        let secondIdentifier = secondAnnouncement.identifier
        let context = ApplicationTestBuilder().build()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        context.application.openAnnouncement(identifier: Announcement2.Identifier(firstIdentifier)) { (_) in }
        context.application.openAnnouncement(identifier: Announcement2.Identifier(secondIdentifier)) { (_) in }
        let expected = [firstIdentifier, secondIdentifier].map({ Announcement2.Identifier($0) })
        let observer = CapturingAnnouncementsServiceObserver()
        context.application.add(observer)
        
        XCTAssertTrue(observer.readAnnouncementIdentifiers.contains(elementsFrom: expected))
    }
    
    func testTellObserversAboutReadAnnouncementsWhenLoadingFromStore() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let announcements = syncResponse.announcements.changed
        let firstAnnouncement = announcements.randomElement().element
        let firstIdentifier = firstAnnouncement.identifier
        let secondAnnouncement = announcements.randomElement().element
        let secondIdentifier = secondAnnouncement.identifier
        let dataStore = CapturingEurofurenceDataStore()
        let identifiers = [firstIdentifier, secondIdentifier].map({ Announcement2.Identifier($0) })
        dataStore.save(syncResponse)
        dataStore.performTransaction { (transaction) in
            transaction.saveReadAnnouncements(identifiers)
        }
        
        let context = ApplicationTestBuilder().with(dataStore).build()
        let observer = CapturingAnnouncementsServiceObserver()
        context.application.add(observer)
        
        XCTAssertTrue(observer.readAnnouncementIdentifiers.contains(elementsFrom: identifiers))
    }
    
}
