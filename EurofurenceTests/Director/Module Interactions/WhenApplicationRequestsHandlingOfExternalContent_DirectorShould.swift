//
//  WhenApplicationRequestsHandlingOfExternalContent_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
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
