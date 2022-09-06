import CoreData
@testable import EurofurenceKit
import XCTest

class IngestingFullRemoteModel_DealerDedupeTests: XCTestCase {
    
    func testIngestingFullResponse_DoesNotDuplicateCategories() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        // For each category, there should be one instance with the corresponding name associated with one or more
        // dealers. Witnessing the same category implies it has been duplicated amongst many dealers.
        let fetchRequest: NSFetchRequest<DealerCategory> = DealerCategory.fetchRequest()
        let dealerCategories = try scenario.viewContext.fetch(fetchRequest)
        
        var witnessedCategoriesByName = [String: DealerCategory]()
        for dealerCategory in dealerCategories {
            if witnessedCategoriesByName[dealerCategory.name] != nil {
                XCTFail("Multiple copies of \(dealerCategory.name) in persistent store")
                return
            }
            
            witnessedCategoriesByName[dealerCategory.name] = dealerCategory
            
            XCTAssertGreaterThanOrEqual(dealerCategory.dealers.count, 1)
        }
    }

}
