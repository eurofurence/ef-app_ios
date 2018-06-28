//
//  CoreDataEurofurenceDataStoreShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import CoreData
@testable import Eurofurence
import XCTest

class CoreDataEurofurenceDataStoreShould: XCTestCase {
    
    var storeIdentifier: String!
    var store: CoreDataEurofurenceDataStore!
    
    private func recreateStore() {
        store = CoreDataEurofurenceDataStore(storeName: storeIdentifier)
    }
    
    override func setUp() {
        super.setUp()
        
        storeIdentifier = .random
        recreateStore()
    }
    
    func testSaveLastRefreshDate() {
        let expected = Date.random
        store.performTransaction { (transaction) in
            transaction.saveLastRefreshDate(expected)
        }
        
        recreateStore()
        let actual = store.getLastRefreshDate()
        
        XCTAssertEqual(expected, actual)
    }
    
    func testSaveKnowledgeGroups() {
        let expected = [APIKnowledgeGroup].random
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeGroups(expected)
        }
        
        recreateStore()
        let actual = store.getSavedKnowledgeGroups()
        
        assertThat(expected, isEqualTo: actual)
    }
    
    func testUpdateExistingKnowledgeGroupsByIdentifier() {
        var group = APIKnowledgeGroup.random
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeGroups([group])
        }
        
        group.groupName = .random
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeGroups([group])
        }
        
        let savedGroups = store.getSavedKnowledgeGroups()
        
        XCTAssertEqual(1, savedGroups?.count)
        XCTAssertEqual(group.groupName, savedGroups?.first?.groupName)
    }
    
    func testSaveKnowledgeEntries() {
        let expected = [APIKnowledgeEntry].random.sorted()
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeEntries(expected)
        }
        
        recreateStore()
        let actual = store.getSavedKnowledgeEntries()
        
        assertThat(expected, isEqualTo: actual?.sorted())
    }
    
    func testUpdateExistingKnowledgeEntriesByIdentifier() {
        var entry = APIKnowledgeEntry.random
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeEntries([entry])
        }
        
        entry.title = .random
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeEntries([entry])
        }
        
        let savedEntries = store.getSavedKnowledgeEntries()
        
        XCTAssertEqual(1, savedEntries?.count)
        XCTAssertEqual(entry.title, savedEntries?.first?.title)
    }
    
    // TODO: This is sorta testing internals, but not sure if there's another avenue for us to assert upon
    func testNotDuplicateLinksWhenUpdatingKnowledgeEntries() {
        let entry = APIKnowledgeEntry.random
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeEntries([entry])
        }
        
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeEntries([entry])
        }
        
        let link = entry.links.randomElement().element
        
        let linksFetchRequest: NSFetchRequest<LinkEntity> = LinkEntity.fetchRequest()
        linksFetchRequest.predicate = NSPredicate(format: "\(#keyPath(LinkEntity.name)) == %@ AND \(#keyPath(LinkEntity.target)) == %@ AND \(#keyPath(LinkEntity.fragmentType)) == %li", link.name, link.target, link.fragmentType.rawValue)
        
        store.container.viewContext.performAndWait {
            do {
                let result = try linksFetchRequest.execute()
                XCTAssertEqual(1, result.count)
            }
            catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func testSaveEvents() {
        let expected = [APIEvent].random
        store.performTransaction { (transaction) in
            transaction.saveEvents(expected)
        }
        
        recreateStore()
        let actual = store.getSavedEvents()
        
        assertThat(expected, isEqualTo: actual)
    }
    
    func testUpdateExistingEventsByIdentifier() {
        var event = APIEvent.random
        store.performTransaction { (transaction) in
            transaction.saveEvents([event])
        }
        
        event.title = .random
        store.performTransaction { (transaction) in
            transaction.saveEvents([event])
        }
        
        let savedEntries = store.getSavedEvents()
        
        XCTAssertEqual(1, savedEntries?.count)
        XCTAssertEqual(event.title, savedEntries?.first?.title)
    }
    
    func testSaveRooms() {
        let expected = [APIRoom].random
        store.performTransaction { (transaction) in
            transaction.saveRooms(expected)
        }
        
        recreateStore()
        let actual = store.getSavedRooms()
        
        assertThat(expected, isEqualTo: actual)
    }
    
    func testUpdateExistingRoomsByIdentifier() {
        var room = APIRoom.random
        store.performTransaction { (transaction) in
            transaction.saveRooms([room])
        }
        
        room.name = .random
        store.performTransaction { (transaction) in
            transaction.saveRooms([room])
        }
        
        let savedRooms = store.getSavedRooms()
        
        XCTAssertEqual(1, savedRooms?.count)
        XCTAssertEqual(room.name, savedRooms?.first?.name)
    }
    
    func testSaveTracks() {
        let expected = [APITrack].random
        store.performTransaction { (transaction) in
            transaction.saveTracks(expected)
        }
        
        recreateStore()
        let actual = store.getSavedTracks()
        
        assertThat(expected, isEqualTo: actual)
    }
    
    func testUpdateExistingTracksByIdentifier() {
        var track = APITrack.random
        store.performTransaction { (transaction) in
            transaction.saveTracks([track])
        }
        
        track.name = .random
        store.performTransaction { (transaction) in
            transaction.saveTracks([track])
        }
        
        let savedTracks = store.getSavedTracks()
        
        XCTAssertEqual(1, savedTracks?.count)
        XCTAssertEqual(track.name, savedTracks?.first?.name)
    }
    
    func testSaveAnnouncements() {
        let expected = [APIAnnouncement].random
        store.performTransaction { (transaction) in
            transaction.saveAnnouncements(expected)
        }
        
        recreateStore()
        let actual = store.getSavedAnnouncements()
        
        assertThat(expected, isEqualTo: actual)
    }
    
    func testUpdateExistingAnnouncementsByIdentifier() {
        var announcement = APIAnnouncement.random
        store.performTransaction { (transaction) in
            transaction.saveAnnouncements([announcement])
        }
        
        announcement.title = .random
        store.performTransaction { (transaction) in
            transaction.saveAnnouncements([announcement])
        }
        
        let savedAnnouncements = store.getSavedAnnouncements()
        
        XCTAssertEqual(1, savedAnnouncements?.count)
        XCTAssertEqual(announcement.title, savedAnnouncements?.first?.title)
    }
    
    func testSaveFavouriteEventIdentifiers() {
        let exected = [Event2.Identifier].random
        store.performTransaction { (transaction) in
            exected.forEach(transaction.saveFavouriteEventIdentifier)
        }
        
        recreateStore()
        let actual = store.getSavedFavouriteEventIdentifiers()
        
        assertThat(exected.sorted(), isEqualTo: actual?.sorted())
    }
    
    func testDeleteSavedFavouriteEventIdentifiers() {
        let identifier = Event2.Identifier.random
        store.performTransaction { (transaction) in
            transaction.saveFavouriteEventIdentifier(identifier)
        }
        
        store.performTransaction { (transaction) in
            transaction.deleteFavouriteEventIdentifier(identifier)
        }
        
        let actual = store.getSavedFavouriteEventIdentifiers()
        
        assertThat([], isEqualTo: actual)
    }
    
    func testSaveConferenceDays() {
        let conferenceDays = [APIConferenceDay].random
        store.performTransaction { (transaction) in
            transaction.saveConferenceDays(conferenceDays)
        }
        
        recreateStore()
        let actual = store.getSavedConferenceDays()
        
        assertThat(conferenceDays, isEqualTo: actual)
    }
    
    func testUpdateExistingConferenceDaysByIdentifier() {
        var conferenceDay = APIConferenceDay.random
        store.performTransaction { (transaction) in
            transaction.saveConferenceDays([conferenceDay])
        }
        
        conferenceDay.date = .random
        store.performTransaction { (transaction) in
            transaction.saveConferenceDays([conferenceDay])
        }
        
        let savedConferenceDays = store.getSavedConferenceDays()
        
        XCTAssertEqual(1, savedConferenceDays?.count)
        XCTAssertEqual(conferenceDay.date, savedConferenceDays?.first?.date)
    }
    
    func testSaveDealers() {
        let dealers = [APIDealer].random
        store.performTransaction { (transaction) in
            transaction.saveDealers(dealers)
        }
        
        recreateStore()
        let actual = store.getSavedDealers()
        
        assertThat(dealers, isEqualTo: actual)
    }
    
    func testUpdateExistingDealersByIdentifier() {
        var dealer = APIDealer.random
        store.performTransaction { (transaction) in
            transaction.saveDealers([dealer])
        }
        
        dealer.attendeeNickname = .random
        store.performTransaction { (transaction) in
            transaction.saveDealers([dealer])
        }
        
        let savedDealers = store.getSavedDealers()
        
        XCTAssertEqual(1, savedDealers?.count)
        XCTAssertEqual(dealer.attendeeNickname, savedDealers?.first?.attendeeNickname)
    }
    
    func testSaveMaps() {
        let maps = [APIMap].random
        store.performTransaction { (transaction) in
            transaction.saveMaps(maps)
        }
        
        recreateStore()
        let actual = store.getSavedMaps()
        
        assertThat(maps, isEqualTo: actual)
    }
    
    func testUpdateExistingMapsByIdentifier() {
        var map = APIMap.random
        store.performTransaction { (transaction) in
            transaction.saveMaps([map])
        }
        
        map.mapDescription = .random
        store.performTransaction { (transaction) in
            transaction.saveMaps([map])
        }
        
        let savedMaps = store.getSavedMaps()
        
        XCTAssertEqual(1, savedMaps?.count)
        XCTAssertEqual(map.mapDescription, savedMaps?.first?.mapDescription)
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
