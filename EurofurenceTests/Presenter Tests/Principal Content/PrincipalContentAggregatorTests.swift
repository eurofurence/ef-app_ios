import Eurofurence
import XCTest

class PrincipalContentAggregatorTests: XCTestCase {
    
    func testWrapsInputControllersInsideNavigationAndTabControllers() throws {
        let (first, second) = (StubContentControllerFactory(), StubContentControllerFactory())
        let aggregator = PrincipalContentAggregator(contentControllerFactories: [first, second])
        let principalModule = aggregator.makePrincipalContentModule()
        
        let tabController = try XCTUnwrap(principalModule as? UITabBarController)
        let firstNav = try XCTUnwrap(tabController.viewControllers?[0] as? UINavigationController)
        let secondNav = try XCTUnwrap(tabController.viewControllers?[1] as? UINavigationController)
        
        XCTAssertEqual(firstNav.viewControllers.first, first.stubInterface)
        XCTAssertEqual(secondNav.viewControllers.first, second.stubInterface)
    }

}
