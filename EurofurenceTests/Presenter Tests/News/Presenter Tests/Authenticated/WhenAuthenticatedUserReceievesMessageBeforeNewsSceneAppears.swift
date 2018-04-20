//
//  WhenAuthenticatedUserReceievesMessageBeforeNewsSceneAppears.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenAuthenticatedUserReceievesMessageBeforeNewsSceneAppears: XCTestCase {
    
    func testTheWelcomeLabelIsNotUpdated() {
        let context = NewsPresenterTestBuilder().withUser().build()
        context.privateMessagesService.notifyUnreadCountDidChange(to: 0)
        
        XCTAssertNil(context.newsScene.capturedWelcomeDescription)
    }
    
}
