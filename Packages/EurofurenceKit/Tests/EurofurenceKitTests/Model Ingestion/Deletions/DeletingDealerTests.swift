import EurofurenceKit
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

}
