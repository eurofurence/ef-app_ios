import EurofurenceClipLogic
import UIKit
import XCTest

class RootContainerViewControllerTests: XCTestCase {
    
    func testReplacingRoot_NoneAlreadySet() {
        let container = RootContainerViewController()
        let root = UIViewController()
        container.replaceRoot(with: root)
        
        XCTAssertIdentical(container, root.parent)
        XCTAssertIdentical(container.view, root.view.superview)
    }
    
    func testReplacingRoot_PreviousRootIsRemoved() {
        let container = RootContainerViewController()
        let firstRoot = UIViewController()
        container.replaceRoot(with: firstRoot)
        
        let secondRoot = UIViewController()
        container.replaceRoot(with: secondRoot)
        
        XCTAssertNil(firstRoot.parent)
        XCTAssertNil(firstRoot.view.superview)
        XCTAssertIdentical(container, secondRoot.parent)
        XCTAssertIdentical(container.view, secondRoot.view.superview)
    }
    
}
