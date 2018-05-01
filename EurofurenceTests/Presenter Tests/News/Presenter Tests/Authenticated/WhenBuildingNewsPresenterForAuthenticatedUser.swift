//
//  WhenBuildingNewsPresenterForAuthenticatedUser.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBuildingNewsPresenterForAuthenticatedUser: XCTestCase {
    
    var context: NewsPresenterTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        context = NewsPresenterTestBuilder().withUser().build()
    }
    
    func testTheShowMessagesCommandIsNotRan() {
        XCTAssertFalse(context.delegate.showPrivateMessagesRequested)
    }
    
}
