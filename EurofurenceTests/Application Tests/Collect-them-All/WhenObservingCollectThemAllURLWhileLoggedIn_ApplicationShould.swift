//
//  WhenObservingCollectThemAllURLWhileLoggedIn_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenObservingCollectThemAllURLWhileLoggedIn_ApplicationShould: XCTestCase {
    
    func testEmitAuthenticatedGameURLForUser() {
        let collectThemAllRequestFactory = StubCollectThemAllRequestFactory()
        let credential = Credential(username: .random,
                                    registrationNumber: .random,
                                    authenticationToken: .random,
                                    tokenExpiryDate: .random)
        let context = ApplicationTestBuilder().with(collectThemAllRequestFactory).with(credential).build()
        let observer = CapturingCollectThemAllURLObserver()
        context.application.subscribe(observer)
        let expected = collectThemAllRequestFactory.makeAuthenticatedGameURLRequest(credential: credential)
        
        XCTAssertEqual(expected, observer.capturedURLRequest)
    }
    
    func testUpdateTheObserversWithTheAnonymousRequestWhenLoggingOut() {
        let collectThemAllRequestFactory = StubCollectThemAllRequestFactory()
        let credential = Credential(username: .random,
                                    registrationNumber: .random,
                                    authenticationToken: .random,
                                    tokenExpiryDate: .random)
        let context = ApplicationTestBuilder().with(collectThemAllRequestFactory).with(credential).build()
        let observer = CapturingCollectThemAllURLObserver()
        context.application.subscribe(observer)
        context.application.logout() { (_) in }
        context.capturingTokenRegistration.succeedLastRequest()
        
        XCTAssertEqual(collectThemAllRequestFactory.anonymousGameURLRequest, observer.capturedURLRequest)
    }
    
}
