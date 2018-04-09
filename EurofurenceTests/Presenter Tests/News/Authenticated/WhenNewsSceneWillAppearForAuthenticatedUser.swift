//
//  WhenNewsSceneWillAppearForAuthenticatedUser.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenNewsSceneWillAppearForAuthenticatedUser: XCTestCase {
    
    var user: User!
    var context: NewsPresenterTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        user = .random
        context = NewsPresenterTestBuilder().withUser(user).build()
        context.simulateNewsSceneWillAppear()
    }
    
    func testTheSceneIsToldToShowTheMessagesNavigationAction() {
        XCTAssertTrue(context.newsScene.wasToldToShowMessagesNavigationAction)
    }
    
    func testTheSceneIsToldToHideTheLoginNavigationAction() {
        XCTAssertTrue(context.newsScene.wasToldToHideLoginNavigationAction)
    }
    
    func testTheWelcomePromptShouldBeSourcedUsingTheUser() {
        XCTAssertEqual(context.newsScene.capturedWelcomePrompt, .welcomePrompt(for: user))
    }
    
    func testTheWelcomeDescriptionShouldbeSourcedUsingTheUnreadMessageCount() {
        XCTAssertEqual("", context.newsScene.capturedWelcomeDescription)
    }
    
}
