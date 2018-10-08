//
//  DefaultCollectThemAllRequestFactoryShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class DefaultCollectThemAllRequestFactoryShould: XCTestCase {
    
    func testProduceExpectedAnonymousRequest() {
        let factory = DefaultCollectThemAllRequestFactory()
        let anonymousRequest = factory.makeAnonymousGameURLRequest()
        let expectedURL = URL(string: "https://app.eurofurence.org/collectemall/#token-empty/true")!
        
        XCTAssertEqual(expectedURL, anonymousRequest.url)
    }
    
    func testProduceExpectedAuthenticatedRequest() {
        let factory = DefaultCollectThemAllRequestFactory()
        let credential = Credential(username: .random,
                                    registrationNumber: .random,
                                    authenticationToken: .random,
                                    tokenExpiryDate: .random)
        let authenticatedRequest = factory.makeAuthenticatedGameURLRequest(credential: credential)
        let expectedURL = URL(string: "https://app.eurofurence.org/collectemall/#token-\(credential.authenticationToken)/true")!
        
        XCTAssertEqual(expectedURL, authenticatedRequest.url)
    }
    
}
