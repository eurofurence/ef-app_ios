//
//  WhenAuthenticatedUserInstigatesShowMessagesAction_NewsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenAuthenticatedUserInstigatesShowMessagesAction_NewsPresenterShould: XCTestCase {
    
    func testTellTheDelegateToShowPrivateMessages() {
        let context = NewsPresenterTestBuilder().withUser().build()
        context.newsScene.tapShowMessagesAction()
        
        XCTAssertTrue(context.delegate.showPrivateMessagesRequested)
    }
    
}
