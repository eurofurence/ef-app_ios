@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

class DayTests: EurofurenceKitTestCase {
    
    func testFetchingDaysSortsThemTemporally() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let fetchRequest = Day.temporallyOrderedFetchRequest()
        let days = try scenario.viewContext.fetch(fetchRequest)
        
        let expectedDayNamesOrderedTemporally: [String] = [
            "Early Arrival",
            "Official Con Start/Con Day 1",
            "Con Day 2",
            "Con Day 3",
            "Con Day 4",
            "Last Day/Con Day 5"
        ]
        
        let actualDayNames = days.map(\.name)
        
        XCTAssertEqual(expectedDayNamesOrderedTemporally, actualDayNames, "Expected to sort days by their date")
    }

}
