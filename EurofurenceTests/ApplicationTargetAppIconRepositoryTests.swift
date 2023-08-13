import Eurofurence
import EurofurenceApplication
import XCTest

class ApplicationTargetAppIconRepositoryTests: XCTestCase {
    
    func testContainsExpectedIcons() {
        let expectedIconsWithinApplicationBundle: [AppIcon] = [
            .init(displayName: "Classic", imageFileName: "Classic", alternateIconName: "Classic"),
            .init(displayName: "Black Magic", imageFileName: "Themed", alternateIconName: nil)
        ]
        
        let repository = ApplicationTargetAppIconRepository()
        let actual = repository.loadAvailableIcons()
        
        XCTAssertEqual(expectedIconsWithinApplicationBundle, actual)
    }
    
}
