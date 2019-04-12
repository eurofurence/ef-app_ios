@testable import Eurofurence
import EurofurenceModel
import XCTest

class AppWindowWireframeTests: XCTestCase {

    func testSettingTheRootViewControllerSetsItAsTheRootControllerOnTheWindow() {
        let window = UIWindow()
        let wireframe = AppWindowWireframe(window: window)
        let vc = UIViewController()
        wireframe.setRoot(vc)

        XCTAssertEqual(vc, window.rootViewController)
    }

}
