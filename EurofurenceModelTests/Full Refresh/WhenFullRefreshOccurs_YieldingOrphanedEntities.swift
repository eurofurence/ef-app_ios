import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenFullRefreshOccurs_YieldingOrphanedEntities: XCTestCase {

    var context: EurofurenceSessionTestBuilder.Context!
    var originalResponse: ModelCharacteristics!
    var fullSyncResponse: ModelCharacteristics!

    override func setUp() {
        super.setUp()

        let store = FakeDataStore()
        let forceRefreshRequired = StubForceRefreshRequired(isForceRefreshRequired: true)
        
        context = EurofurenceSessionTestBuilder().with(store).build()
        originalResponse = .randomWithoutDeletions
        fullSyncResponse = .randomWithoutDeletions
        context.performSuccessfulSync(response: originalResponse)
        context = EurofurenceSessionTestBuilder().with(store).with(forceRefreshRequired).build()
        _ = context.refreshService.refreshLocalStore { (_) in }
        context.api.simulateSuccessfulSync(fullSyncResponse)
    }

    func testTheOrphanedAnnouncementsAreRemoved() {
        let announcementsObserver = CapturingAnnouncementsServiceObserver()
        context.announcementsService.add(announcementsObserver)
        let originalAnnouncementIdentifiers = originalResponse.announcements.changed.identifiers
        let announcementIdentifiers = announcementsObserver.allAnnouncements.map({ $0.identifier.rawValue })

        XCTAssertFalse(announcementIdentifiers.contains(elementsFrom: originalAnnouncementIdentifiers))
    }

    func testTheOrphanedEventsAreRemoved() {
        let eventsObserver = CapturingEventsServiceObserver()
        context.eventsService.add(eventsObserver)
        let originalEventIdentifiers = originalResponse.events.changed.identifiers
        let eventIdentifiers = eventsObserver.allEvents.map({ $0.identifier.rawValue })

        XCTAssertFalse(eventIdentifiers.contains(elementsFrom: originalEventIdentifiers))
    }

    func testTheOrphanedKnowledgeGroupsAreRemoved() {
        let knowledgeObserver = CapturingKnowledgeServiceObserver()
        context.knowledgeService.add(knowledgeObserver)
        let originalGroupIdentifiers = originalResponse.knowledgeGroups.changed.identifiers
        let groupIdentifiers = knowledgeObserver.capturedGroups.map({ $0.identifier.rawValue })

        XCTAssertFalse(groupIdentifiers.contains(elementsFrom: originalGroupIdentifiers))
    }

    func testTheOrphanedKnowledgeEntriesAreRemoved() {
        let originalKnowledgeEntries = originalResponse.knowledgeEntries.changed
        let persistedKnowledgeEntries = context.dataStore.fetchKnowledgeEntries()
        XCTAssertEqual(false, persistedKnowledgeEntries?.containsAny(elementsFrom: originalKnowledgeEntries))
    }

    func testTheOrphanedImagesAreRemoved() {
        let imageIdentifiers = originalResponse.images.changed.identifiers
        let deletedImageIdentifiers = context.imageRepository.deletedImages

        XCTAssertTrue(deletedImageIdentifiers.contains(elementsFrom: imageIdentifiers))
    }

    func testTheOrphanedDealersAreRemoved() {
        let delegate = CapturingDealersIndexDelegate()
        let index = context.dealersService.makeDealersIndex()
        index.setDelegate(delegate)
        let originalDealerIdentifiers = originalResponse.dealers.changed.identifiers
        let dealerIdentifiers = delegate.capturedAlphabetisedDealerGroups.reduce([], { $0 + $1.dealers }).map({ $0.identifier.rawValue })

        XCTAssertFalse(dealerIdentifiers.contains(elementsFrom: originalDealerIdentifiers))
    }

    func testTheOrphanedMapsAreRemoved() {
        let mapsObserver = CapturingMapsObserver()
        context.mapsService.add(mapsObserver)
        let originalMapsIdentifiers = originalResponse.maps.changed.identifiers
        let mapsIdentifiers = mapsObserver.capturedMaps.map({ $0.identifier.rawValue })

        XCTAssertFalse(mapsIdentifiers.contains(elementsFrom: originalMapsIdentifiers))
    }

}
