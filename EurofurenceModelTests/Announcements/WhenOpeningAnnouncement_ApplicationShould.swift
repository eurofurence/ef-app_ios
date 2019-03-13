//
//  WhenOpeningAnnouncement_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenOpeningAnnouncement_ApplicationShould: XCTestCase {

    var context: EurofurenceSessionTestBuilder.Context!
    var syncResponse: ModelCharacteristics!

    override func setUp() {
        super.setUp()

        context = EurofurenceSessionTestBuilder().build()
        syncResponse = ModelCharacteristics.randomWithoutDeletions
        context.performSuccessfulSync(response: syncResponse)
    }

    @discardableResult
    private func openAnnouncement(_ identifier: AnnouncementIdentifier) -> Announcement? {
        var announcement: Announcement?
        context.announcementsService.fetchAnnouncement(identifier: identifier) { announcement = $0 }

        return announcement
    }

    func testProvideTheAnnouncementToTheCompletionHandler() {
        let announcements = syncResponse.announcements.changed
        let announcement = announcements.randomElement().element
        let identifier = announcement.identifier
        let model = openAnnouncement(AnnouncementIdentifier(identifier))

        AnnouncementAssertion().assertAnnouncement(model, characterisedBy: announcement)
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
        context.announcementsService.add(observer)
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
        context.announcementsService.add(observer)

        XCTAssertTrue(observer.readAnnouncementIdentifiers.contains(elementsFrom: expected))
    }

    func testTellObserversAboutReadAnnouncementsWhenLoadingFromStore() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let announcements = syncResponse.announcements.changed
        let firstAnnouncement = announcements.randomElement().element
        let firstIdentifier = firstAnnouncement.identifier
        let secondAnnouncement = announcements.randomElement().element
        let secondIdentifier = secondAnnouncement.identifier
        let dataStore = FakeDataStore(response: syncResponse)
        let identifiers = [firstIdentifier, secondIdentifier].map({ AnnouncementIdentifier($0) })
        dataStore.save(syncResponse)
        dataStore.performTransaction { (transaction) in
            transaction.saveReadAnnouncements(identifiers)
        }

        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let observer = CapturingAnnouncementsServiceObserver()
        context.announcementsService.add(observer)

        XCTAssertTrue(observer.readAnnouncementIdentifiers.contains(elementsFrom: identifiers))
    }

}
