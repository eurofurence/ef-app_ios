//
//  WhenObservingCollectThemAllURLWhileLoggedOut_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenObservingCollectThemAllURLWhileLoggedOut_ApplicationShould: XCTestCase {
    
    func testEmitAnonymousGameURL() {
        let collectThemAllRequestFactory = StubCollectThemAllRequestFactory()
        let context = ApplicationTestBuilder().with(collectThemAllRequestFactory).build()
        let observer = CapturingCollectThemAllURLObserver()
        context.application.subscribe(observer)
        
        XCTAssertEqual(collectThemAllRequestFactory.anonymousGameURLRequest, observer.capturedURLRequest)
    }
    
}
