import Eurofurence
import XCTest

class AppIconRepositoryTests: XCTestCase {
    
    func testContainsExpectedIcons() {
        let expectedIconsWithinApplicationBundle: [AppIcon] = [
            .init(displayName: "Classic", imageFileName: "ClassicAppIcon"),
            .init(displayName: "On the High Seas", imageFileName: "OnTheHighSeasAppIcon")
        ]
        
        let repository = ApplicationTargetAppIconRepository()
        let actual = repository.loadAvailableIcons()
        
        XCTAssertEqual(expectedIconsWithinApplicationBundle, actual)
    }
    
}
