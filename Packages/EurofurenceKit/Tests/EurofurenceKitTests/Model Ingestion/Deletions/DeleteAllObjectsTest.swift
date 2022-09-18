import CoreData
@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

class DeleteAllObjectsTest: EurofurenceKitTestCase {

    func testDeletingAllEntities() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        let deleteAllPayload = try SampleResponse.deleteAll.loadResponse()
        await scenario.stubSyncResponse(with: .success(deleteAllPayload), for: payload.synchronizationToken)
        try await scenario.updateLocalStore()
        
        let entityTypes: [Entity.Type] = [
            Announcement.self,
            Day.self,
            Dealer.self,
            Event.self,
            Image.self,
            KnowledgeEntry.self,
            KnowledgeGroup.self,
            Map.self,
            Room.self,
            Track.self
        ]
        
        for entityType in entityTypes {
            let entityName = try XCTUnwrap(entityType.entity().name)
            let fetchRequest: NSFetchRequest<NSManagedObjectID> = NSFetchRequest(entityName: entityName)
            fetchRequest.resultType = .managedObjectIDResultType
            let objectsIDs = try scenario.viewContext.fetch(fetchRequest)
            
            XCTAssertTrue(
                objectsIDs.isEmpty,
                "Expected all \(String(describing: entityType)) entities to be deleted. Still present: \(objectsIDs)"
            )
        }
    }
    
    func testDeletingEverythingAlsoDeletesImages() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        let fetchRequest: NSFetchRequest<EurofurenceKit.Image> = EurofurenceKit.Image.fetchRequest()
        fetchRequest.predicate = NSPredicate(value: true)
        
        let images = try scenario.viewContext.fetch(fetchRequest)
        let imageURLs = images.compactMap(\.cachedImageURL)
        
        let deleteAllPayload = try SampleResponse.deleteAll.loadResponse()
        await scenario.stubSyncResponse(with: .success(deleteAllPayload), for: payload.synchronizationToken)
        try await scenario.updateLocalStore()
        
        for imageURL in imageURLs {
            XCTAssertTrue(
                scenario.modelProperties.removedContainerResource(at: imageURL),
                "Failed to request deletion of image at url: \(imageURL)"
            )
        }
    }

}
