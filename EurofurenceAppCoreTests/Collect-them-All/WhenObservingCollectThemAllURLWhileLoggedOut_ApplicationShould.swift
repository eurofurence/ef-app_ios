//
//  WhenObservingCollectThemAllURLWhileLoggedOut_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenObservingCollectThemAllURLWhileLoggedOut_ApplicationShould: XCTestCase {

    func testEmitAnonymousGameURL() {
        let collectThemAllRequestFactory = StubCollectThemAllRequestFactory()
        let context = ApplicationTestBuilder().with(collectThemAllRequestFactory).build()
        let observer = CapturingCollectThemAllURLObserver()
        context.application.subscribe(observer)

        XCTAssertEqual(collectThemAllRequestFactory.anonymousGameURLRequest, observer.capturedURLRequest)
    }

    func testEmitAuthenticatedGameURLForUserWhenLoggingIn() {
        let collectThemAllRequestFactory = StubCollectThemAllRequestFactory()
        let context = ApplicationTestBuilder().with(collectThemAllRequestFactory).build()
        let observer = CapturingCollectThemAllURLObserver()
        context.application.subscribe(observer)
        let args = LoginArguments(registrationNumber: .random, username: .random, password: .random)
        context.application.login(args) { (_) in }
        let response = LoginResponse(userIdentifier: .random, username: .random, token: .random, tokenValidUntil: .random)
        context.loginAPI.simulateResponse(response)
        let expectedCredential = Credential(username: response.username, registrationNumber: args.registrationNumber, authenticationToken: response.token, tokenExpiryDate: response.tokenValidUntil)
        let expected = collectThemAllRequestFactory.makeAuthenticatedGameURLRequest(credential: expectedCredential)

        XCTAssertEqual(expected, observer.capturedURLRequest)
    }

}
