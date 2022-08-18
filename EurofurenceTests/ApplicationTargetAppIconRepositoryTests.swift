import Eurofurence
import EurofurenceApplication
import XCTest

class ApplicationTargetAppIconRepositoryTests: XCTestCase {
    
    func testContainsExpectedIcons() {
        let expectedIconsWithinApplicationBundle: [AppIcon] = [
            .init(displayName: "Classic", imageFileName: "Classic", alternateIconName: "Classic"),
            .init(displayName: "On the High Seas", imageFileName: "Pirate", alternateIconName: nil)
        ]
        
        let repository = ApplicationTargetAppIconRepository()
        let actual = repository.loadAvailableIcons()
        
        XCTAssertEqual(expectedIconsWithinApplicationBundle, actual)
    }
    
}