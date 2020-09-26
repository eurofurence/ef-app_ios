import Eurofurence
import XCTest

class URLBasedActivityItemTestCase: XCTestCase {
    
    private(set) var activityViewController: UIActivityViewController!
    
    override func setUp() {
        super.setUp()
        activityViewController = UIActivityViewController(activityItems: [], applicationActivities: nil)
    }
    
    func makeActivityItem() throws -> URLBasedActivityItem {
        let url = try XCTUnwrap(URL(string: "https://test.com"))
        return URLBasedActivityItem(url: url)
    }
    
    func testUsesURLForPlaceholderItem() throws {
        let activityItem = try makeActivityItem()
        let expected = activityItem.url
        let activityController = UIActivityViewController(activityItems: [], applicationActivities: nil)
        let actual = activityItem.activityViewController(activityController, itemForActivityType: nil)
        
        XCTAssertEqual(expected, actual as? URL)
    }
    
    func testItemUsesURL() throws {
        let activityItem = try makeActivityItem()
        let expected = activityItem.url
        let activityController = UIActivityViewController(activityItems: [], applicationActivities: nil)
        let actual = activityItem.activityViewController(activityController, itemForActivityType: nil)
        
        XCTAssertEqual(expected, actual as? URL)
    }

}
