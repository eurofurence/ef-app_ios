//
//  WhenFullRefreshOccurs_YieldingOrphanedEntities.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenFullRefreshOccurs_YieldingOrphanedEntities: XCTestCase {

    var context: ApplicationTestBuilder.Context!
    var originalResponse: APISyncResponse!
    var fullSyncResponse: APISyncResponse!

    override func setUp() {
        super.setUp()

        context = ApplicationTestBuilder().build()
        originalResponse = .randomWithoutDeletions
        fullSyncResponse = .randomWithoutDeletions
        context.performSuccessfulSync(response: originalResponse)
        _ = context.application.performFullStoreRefresh { (_) in }
        context.syncAPI.simulateSuccessfulSync(fullSyncResponse)
    }

    func testTheOrphanedAnnouncementsAreRemoved() {
        let announcementsObserver = CapturingAnnouncementsServiceObserver()
        context.application.add(announcementsObserver)
        let originalAnnouncementIdentifiers = originalResponse.announcements.changed.map({ $0.identifier })
        let announcementIdentifiers = announcementsObserver.allAnnouncements.map({ $0.identifier.rawValue })

        XCTAssertFalse(announcementIdentifiers.contains(elementsFrom: originalAnnouncementIdentifiers))
    }

    func testTheOrphanedEventsAreRemoved() {
        let eventsObserver = CapturingEventsServiceObserver()
        context.application.add(eventsObserver)
        let originalEventIdentifiers = originalResponse.events.changed.map({ $0.identifier })
        let eventIdentifiers = eventsObserver.allEvents.map({ $0.identifier.rawValue })

        XCTAssertFalse(eventIdentifiers.contains(elementsFrom: originalEventIdentifiers))
    }

    func testTheOrphanedKnowledgeGroupsAreRemoved() {
        let knowledgeObserver = CapturingKnowledgeServiceObserver()
        context.application.add(knowledgeObserver)
        let originalGroupIdentifiers = originalResponse.knowledgeGroups.changed.map({ $0.identifier })
        let groupIdentifiers = knowledgeObserver.capturedGroups.map({ $0.identifier.rawValue })

        XCTAssertFalse(groupIdentifiers.contains(elementsFrom: originalGroupIdentifiers))
    }

    func testTheOrphanedKnowledgeEntriesAreRemoved() {
        let knowledgeObserver = CapturingKnowledgeServiceObserver()
        context.application.add(knowledgeObserver)
        let originalEntryIdentifiers = originalResponse.knowledgeEntries.changed.map({ $0.identifier })

        XCTAssertTrue(context.dataStore.transaction.deletedKnowledgeEntries.contains(elementsFrom: originalEntryIdentifiers))
    }

    func testTheOrphanedImagesAreRemoved() {
        let imageIdentifiers = originalResponse.images.changed.map({ $0.identifier })
        let deletedImageIdentifiers = context.imageRepository.deletedImages

        XCTAssertTrue(deletedImageIdentifiers.contains(elementsFrom: imageIdentifiers))
    }

    func testTheOrphanedDealersAreRemoved() {
        let delegate = CapturingDealersIndexDelegate()
        let index = context.application.makeDealersIndex()
        index.setDelegate(delegate)
        let originalDealerIdentifiers = originalResponse.dealers.changed.map({ $0.identifier })
        let dealerIdentifiers = delegate.capturedAlphabetisedDealerGroups.reduce([], { $0 + $1.dealers }).map({ $0.identifier.rawValue })

        XCTAssertFalse(dealerIdentifiers.contains(elementsFrom: originalDealerIdentifiers))
    }

    func testTheOrphanedMapsAreRemoved() {
        let mapsObserver = CapturingMapsObserver()
        context.application.add(mapsObserver)
        let originalMapsIdentifiers = originalResponse.maps.changed.map({ $0.identifier })
        let mapsIdentifiers = mapsObserver.capturedMaps.map({ $0.identifier.rawValue })

        XCTAssertFalse(mapsIdentifiers.contains(elementsFrom: originalMapsIdentifiers))
    }

}
