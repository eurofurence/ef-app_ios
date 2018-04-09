//
//  WhenUnauthenticatedUserLogsIn_NewsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenUnauthenticatedUserLogsIn_NewsPresenterShould: XCTestCase {
    
    var user: User!
    var context: NewsPresenterTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        user = .random
        context = NewsPresenterTestBuilder().withUser().build()
        context.simulateNewsSceneWillAppear()
        context.authService.notifyObserversUserDidLogin(user)
    }
    
    func testWhenAuthServiceIndicatesUserLoggedInTheSceneShouldShowTheMessagesNavigationAction() {
        XCTAssertTrue(context.newsScene.wasToldToShowMessagesNavigationAction)
    }
    
    func testWhenAuthServiceIndicatesUserLoggedInTheSceneShouldHideTheLoginNavigationAction() {
        XCTAssertTrue(context.newsScene.wasToldToHideLoginNavigationAction)
    }
    
    func testWhenAuthServiceIndicatesUserLoggedInTheWelcomePromptShouldBeSourcedUsingTheUser() {
        XCTAssertEqual(context.newsScene.capturedWelcomePrompt, .welcomePrompt(for: user))
    }
    
}
