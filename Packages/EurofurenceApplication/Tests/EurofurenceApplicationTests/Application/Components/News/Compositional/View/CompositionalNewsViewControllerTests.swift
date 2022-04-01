import EurofurenceApplication
import XCTest

class CompositionalNewsViewControllerTests: XCTestCase {
    
    private var viewController: CompositionalNewsViewController!
    
    override func setUp() {
        super.setUp()
        
        viewController = CompositionalNewsViewController()
        viewController.loadView()
        viewController.viewDidLoad()
    }
    
    func testUsesTitle() {
        XCTAssertEqual("News", viewController.navigationItem.title)
    }
    
    func testUsesTabBarItemTitle() {
        XCTAssertEqual("News", viewController.tabBarItem.title)
    }
    
    func testUsesTabBarItemImage() {
        XCTAssertNotNil(viewController.tabBarItem.image)
    }
    
}
