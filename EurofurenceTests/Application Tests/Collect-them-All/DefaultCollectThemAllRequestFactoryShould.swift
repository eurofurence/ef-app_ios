//
//  DefaultCollectThemAllRequestFactoryShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class DefaultCollectThemAllRequestFactoryShould: XCTestCase {
    
    func testProduceExpectedAnonymousRequest() {
        let factory = DefaultCollectThemAllRequestFactory()
        let anonymousRequest = factory.makeAnonymousGameURLRequest()
        let expectedURL = URL(string: "https://app.eurofurence.org/collectemall/")!
        
        XCTAssertEqual(expectedURL, anonymousRequest.url)
    }
    
}
