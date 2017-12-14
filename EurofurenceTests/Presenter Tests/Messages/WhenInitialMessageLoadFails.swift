//
//  WhenInitialMessageLoadFails.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 14/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenInitialMessageLoadFails: XCTestCase {
    
    func testTheRefreshIndicatorIsHidden() {
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.scene.delegate?.messagesSceneWillAppear()
        context.privateMessagesService.failLastRefresh()
        
        XCTAssertTrue(context.scene.wasToldToHideRefreshIndicator)
    }
    
}
