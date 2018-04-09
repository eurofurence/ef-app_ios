//
//  WhenUnauthenticatedUserTapsLoginButton_NewsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenUnauthenticatedUserTapsLoginButton_NewsPresenterShould: XCTestCase {
    
    func testTellTheDelegateLoginRequested() {
        let context = NewsPresenterTestBuilder().build()
        context.newsScene.tapLoginAction()
        
        XCTAssertTrue(context.delegate.loginRequested)
    }
    
}
