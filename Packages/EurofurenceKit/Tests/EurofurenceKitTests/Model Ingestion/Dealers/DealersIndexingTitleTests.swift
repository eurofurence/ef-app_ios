import EurofurenceWebAPI
@testable import EurofurenceKit
import XCTest

class DealersIndexingTitleTests: XCTestCase {
    
    func testDealerWithNoDisplayNameUsesNicknameAsName() async throws {
        // This is a known dealer in the sample file with no display name.
        let (id, nickname) = ("96b4c052-78f3-45bb-b46f-f3ebe4639db4", "Pan Hesekiel Shiroi")
        
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        let dealer = try scenario.model.dealer(identifiedBy: id)
        
        XCTAssertEqual(nickname, dealer.name)
    }
    
    func testDealerWithDisplayNameUsesDisplayNameAsName() async throws {
        // This is a known dealer in the sample file with a display name.
        let (id, displayName) = ("e9ca0f43-9c30-4e0b-b1a1-6f59ceb7f0f7", "FUSSELSCHWARM")
        
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        let dealer = try scenario.model.dealer(identifiedBy: id)
        
        XCTAssertEqual(displayName, dealer.name)
    }
    
    func testDealerWithNoDisplayNameUsesFirstCharacterNicknameAsIndexingTitle() async throws {
        // This is a known dealer in the sample file with no display name.
        let (id, indexingTitle) = ("96b4c052-78f3-45bb-b46f-f3ebe4639db4", "P")
        
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        let dealer = try scenario.model.dealer(identifiedBy: id)
        
        XCTAssertEqual(indexingTitle, dealer.indexingTitle)
    }
    
    func testDealerWithDisplayNameUsesFirstCharacterFromDisplayNameAsIndexingTitle() async throws {
        // This is a known dealer in the sample file with a display name.
        let (id, indexingTitle) = ("e9ca0f43-9c30-4e0b-b1a1-6f59ceb7f0f7", "F")
        
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        let dealer = try scenario.model.dealer(identifiedBy: id)
        
        XCTAssertEqual(indexingTitle, dealer.indexingTitle)
    }

}
