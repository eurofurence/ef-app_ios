import EurofurenceWebAPI
@testable import EurofurenceKit
import XCTest

class DealerCategoriesTests: EurofurenceKitTestCase {
    
    func testFetchingCategoriesSortsAlphabetically() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        // Known categories in response: Prints, Fursuits, Commissions, Artwork, Miscellaneous
        let fetchRequest = DealerCategory.alphabeticallySortedFetchRequest()
        let categories = try scenario.viewContext.fetch(fetchRequest)
        
        let expectedCategoryNames: [String] = [
            "Artwork",
            "Commissions",
            "Fursuits",
            "Miscellaneous",
            "Prints"
        ]
        
        let actualCategoryNames = categories.map(\.name)
        
        XCTAssertEqual(expectedCategoryNames, actualCategoryNames, "Expected dealer categories to be sorted by name")
    }

}
