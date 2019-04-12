@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenApplicationRequestsHandlingOfExternalContent_DirectorShould: XCTestCase {

    func testPresentWebModuleForURL() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let url = URL.random
        context.director.handleExternalContent(url: url)

        let webModuleForURL = context.webModuleProviding.producedWebModules[url]

        XCTAssertNotNil(webModuleForURL)
        XCTAssertEqual(webModuleForURL, context.tabModule.stubInterface.capturedPresentedViewController)
    }

}
