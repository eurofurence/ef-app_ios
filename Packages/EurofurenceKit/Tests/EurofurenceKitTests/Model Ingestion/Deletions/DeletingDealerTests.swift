@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

class DeletingDealerTests: XCTestCase {
    
    func testDeletedDealerRemovedFromStore() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        // Assert the corresponding dealer exists, then is deleted following the next ingestion.
        let dealerIdentifier = "ddf3145c-81f3-4e97-840a-58f7f6683884"
        XCTAssertNoThrow(try scenario.model.dealer(identifiedBy: dealerIdentifier))
        
        try await scenario.updateLocalStore(using: .deletedDealer)
        
        XCTAssertThrowsSpecificError(EurofurenceError.invalidDealer(dealerIdentifier)) {
            _ = try scenario.model.dealer(identifiedBy: dealerIdentifier)
        }
    }
    
    func testDeletingAllDealersWithinCategoryDeletesCategory() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        // We'll delete all dealers within the "Fursuits" category, then assert the category no longer exists
        // within the context once the deletion has processed.
        try await scenario.updateLocalStore(using: .deletedDealersWithinFursuitCategory)
        
        let fursuitDealerCategoryFetchRequest: NSFetchRequest<DealerCategory> = DealerCategory.fetchRequest()
        fursuitDealerCategoryFetchRequest.predicate = NSPredicate(format: "name == \"Fursuits\"")
        fursuitDealerCategoryFetchRequest.fetchLimit = 1
        
        let fetchResults = try scenario.viewContext.fetch(fursuitDealerCategoryFetchRequest)
        
        XCTAssertTrue(fetchResults.isEmpty, "Deleting all dealers within a category should delete the category")
    }

}
