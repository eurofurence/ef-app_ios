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
    
    func testSaveRooms() {
        let expected = [APIRoom].random
        store.performTransaction { (transaction) in
            transaction.saveRooms(expected)
        }
        
        recreateStore()
        let actual = store.getSavedRooms()
        
        assertThat(expected, isEqualTo: actual)
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
    
    func testSaveAnnouncements() {
        let expected = [APIAnnouncement].random
        store.performTransaction { (transaction) in
            transaction.saveAnnouncements(expected)
        }
        
        recreateStore()
        let actual = store.getSavedAnnouncements()
        
        assertThat(expected, isEqualTo: actual)
    }
    
    private func assertThat<T>(_ expected: [T], isEqualTo actual: [T]?, file: StaticString = #file, line: UInt = #line) where T: Equatable {
        guard let actual = actual else {
            XCTFail("Expected actual values, but got nil", file: file, line: line)
            return
        }
        
        XCTAssertTrue(expected.contains(elementsFrom: actual),
                      "Expected \(expected), got \(actual)",
                      file: file,
                      line: line)
    }
    
}
