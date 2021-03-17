import ComponentBase
import LinkPresentation
import XCTest

open class URLBasedActivityItemTestCase: XCTestCase {
    
    private var activityViewController: UIActivityViewController!
    private var activityItem: URLBasedActivityItem!
    
    override open func setUp() {
        super.setUp()
        activityViewController = UIActivityViewController(activityItems: [], applicationActivities: nil)
    }
    
    open func makeActivityItem() throws -> URLBasedActivityItem {
        let url = try XCTUnwrap(URL(string: "https://test.com"))
        return URLBasedActivityItem(url: url)
    }
    
    @available(iOS 13.0, *)
    public func linkMetadata(from activityItem: UIActivityItemSource) -> LPLinkMetadata? {
        activityItem.activityViewControllerLinkMetadata?(activityViewController)
    }
    
    open func testUsesURLForPlaceholderItem() throws {
        activityItem = try makeActivityItem()
        let expected = activityItem.url
        let activityController = UIActivityViewController(activityItems: [], applicationActivities: nil)
        let actual = activityItem.activityViewController(activityController, itemForActivityType: nil)
        
        XCTAssertEqual(expected, actual as? URL)
    }
    
    open func testItemUsesURL() throws {
        activityItem = try makeActivityItem()
        let expected = activityItem.url
        let activityController = UIActivityViewController(activityItems: [], applicationActivities: nil)
        let actual = activityItem.activityViewController(activityController, itemForActivityType: nil)
        
        XCTAssertEqual(expected, actual as? URL)
    }
    
    @available(iOS 13.0, *)
    open func testPreparingLinkMetadata() throws {
        activityItem = try makeActivityItem()
        let linkMetadata = try XCTUnwrap(self.linkMetadata(from: activityItem))
        
        assertAgainstLinkMetadata(linkMetadata, activityItem: activityItem)
    }
    
    @available(iOS 13.0, *)
    open func assertAgainstLinkMetadata(_ metadata: LPLinkMetadata, activityItem: URLBasedActivityItem) {
        XCTAssertEqual(activityItem.url, metadata.url)
        XCTAssertNotNil(metadata.iconProvider)
    }

}
