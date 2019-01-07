//
//  WhenOpeningAnnouncement_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenOpeningAnnouncement_ApplicationShould: XCTestCase {

    var context: ApplicationTestBuilder.Context!
    var syncResponse: APISyncResponse!

    override func setUp() {
        super.setUp()

        context = ApplicationTestBuilder().build()
        syncResponse = APISyncResponse.randomWithoutDeletions
        context.performSuccessfulSync(response: syncResponse)
    }

    @discardableResult
    private func openAnnouncement(_ identifier: AnnouncementIdentifier) -> Announcement? {
        var announcement: Announcement?
        context.application.openAnnouncement(identifier: identifier) { announcement = $0 }

        return announcement
    }

    func testProvideTheAnnouncementToTheCompletionHandler() {
        let announcements = syncResponse.announcements.changed
        let announcement = announcements.randomElement().element
        let identifier = announcement.identifier
        let expected = context.expectedAnnouncement(from: announcement)
        let model = openAnnouncement(AnnouncementIdentifier(identifier))

        XCTAssertEqual(expected, model)
    }

    func testSaveTheAnnouncementIdentifierAsReadAnnouncementToStore() {
        let announcements = syncResponse.announcements.changed
        let announcement = announcements.randomElement().element
        let identifier = announcement.identifier
        openAnnouncement(AnnouncementIdentifier(identifier))

        XCTAssertTrue(context.dataStore.didSaveReadAnnouncement(AnnouncementIdentifier(identifier)))
    }

    func testSaveAllPreviouslyReadAnnouncementIdentifierAsRead() {
        let announcements = syncResponse.announcements.changed
        let firstAnnouncement = announcements.randomElement().element
        let firstIdentifier = firstAnnouncement.identifier
        let secondAnnouncement = announcements.randomElement().element
        let secondIdentifier = secondAnnouncement.identifier
        openAnnouncement(AnnouncementIdentifier(firstIdentifier))
        openAnnouncement(AnnouncementIdentifier(secondIdentifier))
        let expected = [firstIdentifier, secondIdentifier].map({ AnnouncementIdentifier($0) })

        XCTAssertTrue(context.dataStore.didSaveReadAnnouncements(expected))
    }

    func testTellServiceObserversWhenMarkingAnnouncementAsRead() {
        let announcements = syncResponse.announcements.changed
        let firstAnnouncement = announcements.randomElement().element
        let firstIdentifier = firstAnnouncement.identifier
        let secondAnnouncement = announcements.randomElement().element
        let secondIdentifier = secondAnnouncement.identifier
        let observer = CapturingAnnouncementsServiceObserver()
        context.application.add(observer)
        openAnnouncement(AnnouncementIdentifier(firstIdentifier))
        openAnnouncement(AnnouncementIdentifier(secondIdentifier))
        let expected = [firstIdentifier, secondIdentifier].map({ AnnouncementIdentifier($0) })

        XCTAssertTrue(observer.readAnnouncementIdentifiers.contains(elementsFrom: expected))
    }

    func testTellLaterAddedObserversAboutMarkedReadAnnouncements() {
        let announcements = syncResponse.announcements.changed
        let firstAnnouncement = announcements.randomElement().element
        let firstIdentifier = firstAnnouncement.identifier
        let secondAnnouncement = announcements.randomElement().element
        let secondIdentifier = secondAnnouncement.identifier
        openAnnouncement(AnnouncementIdentifier(firstIdentifier))
        openAnnouncement(AnnouncementIdentifier(secondIdentifier))
        let expected = [firstIdentifier, secondIdentifier].map({ AnnouncementIdentifier($0) })
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
        let identifiers = [firstIdentifier, secondIdentifier].map({ AnnouncementIdentifier($0) })
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
