@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenMakingWebModuleWithNonHTTPSchemedLinks: XCTestCase {

    func testItShouldNotImplode_BUG() {
        let module = SafariWebComponentFactory()
        let url = URL(string: "www.eurofurence.de").unsafelyUnwrapped

        // Crashes on the following line when bug is present.
        // -[SFSafariViewController initWithURL:] throws an exception when the URL does not
        // have either a http or https scheme.
        _ = module.makeWebModule(for: url)
    }

}
