import EurofurenceApplication
import XCTest

class CompositionalNewsViewControllerTests: XCTestCase {
    
    private var viewController: CompositionalNewsViewController!
    private var delegate: CapturingCompositionalNewsSceneDelegate!
    
    override func setUp() {
        super.setUp()
        
        delegate = CapturingCompositionalNewsSceneDelegate()
    }
    
    private func prepareViewController() {
        viewController = CompositionalNewsViewController()
        viewController.setDelegate(delegate)
        viewController.loadView()
        viewController.viewDidLoad()
    }
    
    func testNotifiesViewDidLoadOnlyMovingToParentViewController() {
        viewController = CompositionalNewsViewController()
        viewController.setDelegate(delegate)
        viewController.loadView()
        
        XCTAssertFalse(delegate.isSceneReady)
        
        viewController.viewDidLoad()
        
        XCTAssertFalse(delegate.isSceneReady)
        
        viewController.didMove(toParent: nil)
        
        XCTAssertFalse(delegate.isSceneReady)
        
        viewController.didMove(toParent: UIViewController())
        
        XCTAssertTrue(delegate.isSceneReady)
    }
    
    func testUsesTitle() {
        prepareViewController()
        XCTAssertEqual("News", viewController.navigationItem.title)
    }
    
    func testUsesTabBarItemTitle() {
        prepareViewController()
        XCTAssertEqual("News", viewController.tabBarItem.title)
    }
    
    func testUsesTabBarItemImage() {
        prepareViewController()
        XCTAssertNotNil(viewController.tabBarItem.image)
    }
    
    private class CapturingCompositionalNewsSceneDelegate: CompositionalNewsSceneDelegate {
        
        private(set) var isSceneReady = false
        func sceneReady() {
            isSceneReady = true
        }
        
        func reloadRequested() {
            
        }
        
        func settingsTapped(sender: Any) {
            
        }
        
    }
    
}
