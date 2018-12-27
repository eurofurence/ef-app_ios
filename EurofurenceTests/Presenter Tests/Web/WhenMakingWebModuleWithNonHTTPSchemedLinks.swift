//
//  WhenMakingWebModuleWithNonHTTPSchemedLinks.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenMakingWebModuleWithNonHTTPSchemedLinks: XCTestCase {

    func testItShouldNotImplode_BUG() {
        let module = SafariWebModuleProviding()
        let url = URL(string: "www.eurofurence.de")!

        // Crashes on the following line when bug is present.
        // -[SFSafariViewController initWithURL:] throws an exception when the URL does not
        // have either a http or https scheme.
        _ = module.makeWebModule(for: url)
    }

}
