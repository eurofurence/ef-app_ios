//
//  WhenMessagesSceneTapsLogoutButton_MessagesPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 25/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenMessagesSceneTapsLogoutButton_MessagesPresenterShould: XCTestCase {
    
    func testTellTheDelegateToShowTheLoggingOutAlert() {
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.scene.delegate?.messagesSceneWillAppear()
        context.scene.delegate?.messagesSceneDidTapLogoutButton()
        
        XCTAssertTrue(context.delegate.wasToldToShowLoggingOutAlert)
    }
    
}
