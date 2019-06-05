@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenMakingWebModuleWithNonHTTPSchemedLinks: XCTestCase {

    func testItShouldNotImplode_BUG() {
        let module = SafariWebModuleProviding()
        let url = unwrap(URL(string: "www.eurofurence.de"))

        // Crashes on the following line when bug is present.
        // -[SFSafariViewController initWithURL:] throws an exception when the URL does not
        // have either a http or https scheme.
        _ = module.makeWebModule(for: url)
    }

}
