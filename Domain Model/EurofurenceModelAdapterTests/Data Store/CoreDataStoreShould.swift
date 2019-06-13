import CoreData
import EurofurenceModel
import XCTest

class CoreDataStoreShould: DataStoreContract {
    
    private var storeIdentifier: String!
    private var coreDataStore: CoreDataStore!
    private var storeLocation: URL?

    override func setUp() {
        storeIdentifier = .random
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        teardownStore()
    }
    
    override func recreateStore() {
        let store = CoreDataStore(storeName: storeIdentifier)
        storeLocation = store.storeLocation
        coreDataStore = store
        
        self.store = store
    }
    
    override func teardownStore() {
        if let url = storeLocation {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print(error)
            }
        }
    }
    
    func testEnsureLinksDeletedFromRemoteModelAreNotReconstitutedLater_BUG() {
        var entry = KnowledgeEntryCharacteristics.random
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeEntries([entry])
        }
        
        let deletedLink = entry.links.randomElement()
        entry.links.remove(at: deletedLink.index)
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeEntries([entry])
        }
        
        if let entry = store.fetchKnowledgeEntries()?.first {
            XCTAssertFalse(entry.links.contains(deletedLink.element),
                           "Link deleted from remote model not deleted from local data store")
        } else {
            XCTFail("Failed to save knowledge entry into data store")
        }
    }
    
    func testEnsureDeletedMapEntriesAreNotReconstitutedLater_BUG() {
        var map = MapCharacteristics.random
        store.performTransaction { (transaction) in
            transaction.saveMaps([map])
        }
        
        let deletedMapEntry = map.entries.randomElement()
        map.entries.remove(at: deletedMapEntry.index)
        store.performTransaction { (transaction) in
            transaction.saveMaps([map])
        }
        
        if let map = store.fetchMaps()?.first {
            XCTAssertFalse(map.entries.contains(deletedMapEntry.element),
                           "Map entry deleted from remote model not deleted from local data store")
        } else {
            XCTFail("Failed to save knowledge entry into data store")
        }
    }
    
    // TODO: This is sorta testing internals, but not sure if there's another avenue for us to assert upon
    func testNotDuplicateLinksWhenUpdatingKnowledgeEntries() {
        let entry = KnowledgeEntryCharacteristics.random
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeEntries([entry])
        }
        
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeEntries([entry])
        }
        
        let link = entry.links.randomElement().element
        
        let linksFetchRequest: NSFetchRequest<LinkEntity> = LinkEntity.fetchRequest()
        let preidcateFormat = "\(#keyPath(LinkEntity.name)) == %@ AND \(#keyPath(LinkEntity.target)) == %@ AND \(#keyPath(LinkEntity.fragmentType)) == %li"
        linksFetchRequest.predicate = NSPredicate(format: preidcateFormat, link.name, link.target, link.fragmentType.rawValue)
        
        coreDataStore.container.viewContext.performAndWait {
            do {
                let result = try linksFetchRequest.execute()
                XCTAssertEqual(1, result.count)
            } catch {
                XCTFail("\(error)")
            }
        }
    }

}
