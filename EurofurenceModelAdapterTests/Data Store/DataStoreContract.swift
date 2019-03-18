//
//  DataStoreContract.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

// swiftlint:disable file_length
class DataStoreContract: XCTestCase {
    
    var store: DataStore!

    override func setUp() {
        super.setUp()
        recreateStore()
    }
    
    override func tearDown() {
        super.tearDown()
        teardownStore()
    }
    
    func recreateStore() {
        onlyCreateTheInMemoryStoreOnceAsItDoesntMakeSenseOtherwise()
    }
    
    func teardownStore() {
        
    }
    
    private func onlyCreateTheInMemoryStoreOnceAsItDoesntMakeSenseOtherwise() {
        if store == nil {
            store = FakeDataStore()
        }
    }
    
    func testSaveLastRefreshDate() {
        let expected = Date.random
        store.performTransaction { (transaction) in
            transaction.saveLastRefreshDate(expected)
        }
        
        recreateStore()
        let actual = store.fetchLastRefreshDate()
        
        XCTAssertEqual(expected, actual)
    }
    
    func testUseTheLastDavedRefreshDateWhenSavingMultipleTimes() {
        let expected = Date.random
        store.performTransaction { (transaction) in
            transaction.saveLastRefreshDate(.random)
        }
        
        store.performTransaction { (transaction) in
            transaction.saveLastRefreshDate(.random)
        }
        
        store.performTransaction { (transaction) in
            transaction.saveLastRefreshDate(expected)
        }
        
        recreateStore()
        let actual = store.fetchLastRefreshDate()
        
        XCTAssertEqual(expected, actual)
    }
    
    func testSaveKnowledgeGroups() {
        verifySaving(for: [KnowledgeGroupCharacteristics].random,
                     savingBlock: { $0.saveKnowledgeGroups },
                     loadingBlock: { $0.fetchKnowledgeGroups })
    }
    
    func testUpdateExistingKnowledgeGroupsByIdentifier() {
        var group = KnowledgeGroupCharacteristics.random
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeGroups([group])
        }
        
        group.groupName = .random
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeGroups([group])
        }
        
        let savedGroups = store.fetchKnowledgeGroups()
        
        XCTAssertEqual(1, savedGroups?.count)
        XCTAssertEqual(group.groupName, savedGroups?.first?.groupName)
    }
    
    func testSaveKnowledgeEntries() {
        verifySaving(for: [KnowledgeEntryCharacteristics].random,
                     savingBlock: { $0.saveKnowledgeEntries },
                     loadingBlock: { $0.fetchKnowledgeEntries })
    }
    
    func testUpdateExistingKnowledgeEntriesByIdentifier() {
        var entry = KnowledgeEntryCharacteristics.random
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeEntries([entry])
        }
        
        entry.title = .random
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeEntries([entry])
        }
        
        let savedEntries = store.fetchKnowledgeEntries()
        
        XCTAssertEqual(1, savedEntries?.count)
        XCTAssertEqual(entry.title, savedEntries?.first?.title)
    }

    func testSaveEvents() {
        verifySaving(for: [EventCharacteristics].random,
                     savingBlock: { $0.saveEvents },
                     loadingBlock: { $0.fetchEvents })
    }
    
    func testUpdateExistingEventsByIdentifier() {
        var event = EventCharacteristics.random
        store.performTransaction { (transaction) in
            transaction.saveEvents([event])
        }
        
        event.title = .random
        store.performTransaction { (transaction) in
            transaction.saveEvents([event])
        }
        
        let savedEntries = store.fetchEvents()
        
        XCTAssertEqual(1, savedEntries?.count)
        XCTAssertEqual(event.title, savedEntries?.first?.title)
    }
    
    func testSaveRooms() {
        verifySaving(for: [RoomCharacteristics].random,
                     savingBlock: { $0.saveRooms },
                     loadingBlock: { $0.fetchRooms })
    }
    
    func testUpdateExistingRoomsByIdentifier() {
        var room = RoomCharacteristics.random
        store.performTransaction { (transaction) in
            transaction.saveRooms([room])
        }
        
        room.name = .random
        store.performTransaction { (transaction) in
            transaction.saveRooms([room])
        }
        
        let savedRooms = store.fetchRooms()
        
        XCTAssertEqual(1, savedRooms?.count)
        XCTAssertEqual(room.name, savedRooms?.first?.name)
    }
    
    func testSaveTracks() {
        verifySaving(for: [TrackCharacteristics].random,
                     savingBlock: { $0.saveTracks },
                     loadingBlock: { $0.fetchTracks })
    }
    
    func testUpdateExistingTracksByIdentifier() {
        var track = TrackCharacteristics.random
        store.performTransaction { (transaction) in
            transaction.saveTracks([track])
        }
        
        track.name = .random
        store.performTransaction { (transaction) in
            transaction.saveTracks([track])
        }
        
        let savedTracks = store.fetchTracks()
        
        XCTAssertEqual(1, savedTracks?.count)
        XCTAssertEqual(track.name, savedTracks?.first?.name)
    }
    
    func testSaveAnnouncements() {
        verifySaving(for: [AnnouncementCharacteristics].random,
                     savingBlock: { $0.saveAnnouncements },
                     loadingBlock: { $0.fetchAnnouncements })
    }
    
    func testUpdateExistingAnnouncementsByIdentifier() {
        var announcement = AnnouncementCharacteristics.random
        store.performTransaction { (transaction) in
            transaction.saveAnnouncements([announcement])
        }
        
        announcement.title = .random
        store.performTransaction { (transaction) in
            transaction.saveAnnouncements([announcement])
        }
        
        let savedAnnouncements = store.fetchAnnouncements()
        
        XCTAssertEqual(1, savedAnnouncements?.count)
        XCTAssertEqual(announcement.title, savedAnnouncements?.first?.title)
    }
    
    func testSaveFavouriteEventIdentifiers() {
        let exected = [EventIdentifier].random
        store.performTransaction { (transaction) in
            exected.forEach(transaction.saveFavouriteEventIdentifier)
        }
        
        recreateStore()
        let actual = store.fetchFavouriteEventIdentifiers()
        
        assertThat(exected, isEqualTo: actual)
    }
    
    func testNotDuplicatedSavedFavouriteEventIdentifiers() {
        let expected = [EventIdentifier].random
        store.performTransaction { (transaction) in
            expected.forEach(transaction.saveFavouriteEventIdentifier)
        }
        
        store.performTransaction { (transaction) in
            expected.forEach(transaction.saveFavouriteEventIdentifier)
        }
        
        recreateStore()
        let actual = store.fetchFavouriteEventIdentifiers()
        
        XCTAssertEqual(expected.count, actual?.count)
    }
    
    func testDeleteSavedFavouriteEventIdentifiers() {
        let identifier = EventIdentifier.random
        store.performTransaction { (transaction) in
            transaction.saveFavouriteEventIdentifier(identifier)
        }
        
        store.performTransaction { (transaction) in
            transaction.deleteFavouriteEventIdentifier(identifier)
        }
        
        let actual = store.fetchFavouriteEventIdentifiers()
        
        assertThat([], isEqualTo: actual)
    }
    
    func testSaveConferenceDays() {
        verifySaving(for: [ConferenceDayCharacteristics].random,
                     savingBlock: { $0.saveConferenceDays },
                     loadingBlock: { $0.fetchConferenceDays })
    }
    
    func testUpdateExistingConferenceDaysByIdentifier() {
        var conferenceDay = ConferenceDayCharacteristics.random
        store.performTransaction { (transaction) in
            transaction.saveConferenceDays([conferenceDay])
        }
        
        conferenceDay.date = .random
        store.performTransaction { (transaction) in
            transaction.saveConferenceDays([conferenceDay])
        }
        
        let savedConferenceDays = store.fetchConferenceDays()
        
        XCTAssertEqual(1, savedConferenceDays?.count)
        XCTAssertEqual(conferenceDay.date, savedConferenceDays?.first?.date)
    }
    
    func testSaveDealers() {
        verifySaving(for: [DealerCharacteristics].random,
                     savingBlock: { $0.saveDealers },
                     loadingBlock: { $0.fetchDealers })
    }
    
    func testUpdateExistingDealersByIdentifier() {
        var dealer = DealerCharacteristics.random
        store.performTransaction { (transaction) in
            transaction.saveDealers([dealer])
        }
        
        dealer.attendeeNickname = .random
        store.performTransaction { (transaction) in
            transaction.saveDealers([dealer])
        }
        
        let savedDealers = store.fetchDealers()
        
        XCTAssertEqual(1, savedDealers?.count)
        XCTAssertEqual(dealer.attendeeNickname, savedDealers?.first?.attendeeNickname)
    }
    
    func testSaveMaps() {
        verifySaving(for: [MapCharacteristics].random,
                     savingBlock: { $0.saveMaps },
                     loadingBlock: { $0.fetchMaps })
    }
    
    func testUpdateExistingMapsByIdentifier() {
        var map = MapCharacteristics.random
        store.performTransaction { (transaction) in
            transaction.saveMaps([map])
        }
        
        map.mapDescription = .random
        store.performTransaction { (transaction) in
            transaction.saveMaps([map])
        }
        
        let savedMaps = store.fetchMaps()
        
        XCTAssertEqual(1, savedMaps?.count)
        XCTAssertEqual(map.mapDescription, savedMaps?.first?.mapDescription)
    }
    
    func testSaveReadAnnouncements() {
        verifySaving(for: [AnnouncementIdentifier].random,
                     savingBlock: { $0.saveReadAnnouncements },
                     loadingBlock: { $0.fetchReadAnnouncementIdentifiers })
    }
    
    func testSaveImages() {
        verifySaving(for: [ImageCharacteristics].random,
                     savingBlock: { $0.saveImages },
                     loadingBlock: { $0.fetchImages })
    }
    
    func testNotDuplicateReadAnnouncementIdentifiers() {
        let expected = [AnnouncementIdentifier].random
        store.performTransaction { (transaction) in
            transaction.saveReadAnnouncements(expected)
        }
        
        store.performTransaction { (transaction) in
            transaction.saveReadAnnouncements(expected)
        }
        
        let actual = store.fetchReadAnnouncementIdentifiers()
        
        XCTAssertEqual(expected.count, actual?.count)
    }
    
    func testDeleteAnnouncements() {
        let element = AnnouncementCharacteristics.random
        verifyDeletion(for: element,
                       elementIdentifier: element.identifier,
                       savingBlock: { $0.saveAnnouncements },
                       deletionBlock: { $0.deleteAnnouncement },
                       loadingBlock: { $0.fetchAnnouncements })
    }
    
    func testDeleteKnowledgeGroups() {
        let element = KnowledgeGroupCharacteristics.random
        verifyDeletion(for: element,
                       elementIdentifier: element.identifier,
                       savingBlock: { $0.saveKnowledgeGroups },
                       deletionBlock: { $0.deleteKnowledgeGroup },
                       loadingBlock: { $0.fetchKnowledgeGroups })
    }
    
    func testDeleteKnowledgeEntries() {
        let element = KnowledgeEntryCharacteristics.random
        verifyDeletion(for: element,
                       elementIdentifier: element.identifier,
                       savingBlock: { $0.saveKnowledgeEntries },
                       deletionBlock: { $0.deleteKnowledgeEntry },
                       loadingBlock: { $0.fetchKnowledgeEntries })
    }
    
    func testDeleteEvents() {
        let element = EventCharacteristics.random
        verifyDeletion(for: element,
                       elementIdentifier: element.identifier,
                       savingBlock: { $0.saveEvents },
                       deletionBlock: { $0.deleteEvent },
                       loadingBlock: { $0.fetchEvents })
    }
    
    func testDeleteTracks() {
        let element = TrackCharacteristics.random
        verifyDeletion(for: element,
                       elementIdentifier: element.identifier,
                       savingBlock: { $0.saveTracks },
                       deletionBlock: { $0.deleteTrack },
                       loadingBlock: { $0.fetchTracks })
    }
    
    func testDeleteRooms() {
        let element = RoomCharacteristics.random
        verifyDeletion(for: element,
                       elementIdentifier: element.roomIdentifier,
                       savingBlock: { $0.saveRooms },
                       deletionBlock: { $0.deleteRoom },
                       loadingBlock: { $0.fetchRooms })
    }
    
    func testDeleteConferenceDays() {
        let element = ConferenceDayCharacteristics.random
        verifyDeletion(for: element,
                       elementIdentifier: element.identifier,
                       savingBlock: { $0.saveConferenceDays },
                       deletionBlock: { $0.deleteConferenceDay },
                       loadingBlock: { $0.fetchConferenceDays })
    }
    
    func testDeleteDealers() {
        let element = DealerCharacteristics.random
        verifyDeletion(for: element,
                       elementIdentifier: element.identifier,
                       savingBlock: { $0.saveDealers },
                       deletionBlock: { $0.deleteDealer },
                       loadingBlock: { $0.fetchDealers })
    }
    
    func testDeleteMaps() {
        let element = MapCharacteristics.random
        verifyDeletion(for: element,
                       elementIdentifier: element.identifier,
                       savingBlock: { $0.saveMaps },
                       deletionBlock: { $0.deleteMap },
                       loadingBlock: { $0.fetchMaps })
    }
    
    func testDeleteImages() {
        let element = ImageCharacteristics.random
        verifyDeletion(for: element,
                       elementIdentifier: element.identifier,
                       savingBlock: { $0.saveImages },
                       deletionBlock: { $0.deleteImage },
                       loadingBlock: { $0.fetchImages })
    }
    
    func testUpdateExistingImagesByIdentifier() {
        var image = ImageCharacteristics.random
        store.performTransaction { (transaction) in
            transaction.saveImages([image])
        }
        
        image.internalReference = .random
        store.performTransaction { (transaction) in
            transaction.saveImages([image])
        }
        
        let savedImages = store.fetchImages()
        
        XCTAssertEqual(1, savedImages?.count)
        XCTAssertEqual(image.internalReference, savedImages?.first?.internalReference)
    }
    
    private func verifySaving<T>(for elements: [T],
                                 savingBlock: @escaping (DataStoreTransaction) -> ([T]) -> Void,
                                 loadingBlock: (DataStore) -> () -> [T]?,
                                 file: StaticString = #file,
                                 line: UInt = #line) where T: Equatable {
        store.performTransaction { (transaction) in
            let block = savingBlock(transaction)
            block(elements)
        }
        
        recreateStore()
        
        let loader = loadingBlock(store)
        let loaded = loader()
        
        assertThat(elements, isEqualTo: loaded, file: file, line: line)
    }
    
    private func verifyDeletion<T>(for element: T,
                                   elementIdentifier: String,
                                   savingBlock: @escaping (DataStoreTransaction) -> ([T]) -> Void,
                                   deletionBlock: @escaping (DataStoreTransaction) -> (String) -> Void,
                                   loadingBlock: (DataStore) -> () -> [T]?,
                                   file: StaticString = #file,
                                   line: UInt = #line) where T: Equatable {
        store.performTransaction { (transaction) in
            let block = savingBlock(transaction)
            block([element])
        }
        
        store.performTransaction { (transaction) in
            let block = deletionBlock(transaction)
            block(elementIdentifier)
        }
        
        recreateStore()
        
        let loader = loadingBlock(store)
        let elements = loader()
        
        XCTAssertEqual([T](), elements, file: file, line: line)
    }
    
    private func assertThat<T>(_ expected: [T], isEqualTo actual: [T]?, file: StaticString = #file, line: UInt = #line) where T: Equatable {
        guard let actual = actual else {
            XCTFail("Expected actual values, but got nil", file: file, line: line)
            return
        }
        
        for item in expected {
            if actual.contains(item) { continue }
            XCTFail("Did not witness item: \(item)", file: file, line: line)
        }
    }

}
