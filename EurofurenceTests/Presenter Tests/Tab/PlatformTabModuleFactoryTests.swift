@testable import Eurofurence
import EurofurenceModel
import XCTest

class PlatformTabModuleFactoryTests: XCTestCase {

    func testSetsChildModulesAsChildViewControllers() {
        let childModules = [UIViewController(), UIViewController()]
        let factory = PlatformTabModuleFactory()
        let vc = factory.makeTabModule(childModules)
        let actual: [UIViewController] = vc.viewControllers ?? []

        XCTAssertEqual(childModules, actual)
    }

}
