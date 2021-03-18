import EurofurenceApplication
import XCTest

class PrincipalContentAggregatorTests: XCTestCase {
    
    func testWrapsInputControllersInsideNavigationAndTabControllers() throws {
        let contentControllerFactory = StubContentControllerFactory()
        let aggregator = ApplicationPrincipalModuleFactory(applicationModuleFactories: [contentControllerFactory])
        let principalModule = aggregator.makePrincipalContentModule()
        
        let tabController = try XCTUnwrap(principalModule as? UITabBarController)
        let splitViewController = try XCTUnwrap(tabController.viewControllers?[0] as? UISplitViewController)
        let navigationController = try XCTUnwrap(splitViewController.viewControllers[0] as? UINavigationController)
        
        XCTAssertEqual(navigationController.viewControllers.first, contentControllerFactory.stubInterface)
    }

}
