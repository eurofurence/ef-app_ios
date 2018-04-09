//
//  NewsPresenterTestsForLoggedInUser.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class NewsPresenterTestsForLoggedInUser: XCTestCase {
    
    func testTheSceneIsToldToShowTheMessagesNavigationAction() {
        let context = NewsPresenterTestBuilder().withUser().build()
        context.simulateNewsSceneWillAppear()
        
        XCTAssertTrue(context.newsScene.wasToldToShowMessagesNavigationAction)
    }
    
    func testTheSceneIsNotToldToShowTheLoginNavigationAction() {
        let context = NewsPresenterTestBuilder().withUser().build()
        XCTAssertFalse(context.newsScene.wasToldToShowLoginNavigationAction)
    }
    
    func testTheSceneIsToldToHideTheLoginNavigationAction() {
        let context = NewsPresenterTestBuilder().withUser().build()
        context.simulateNewsSceneWillAppear()
        
        XCTAssertTrue(context.newsScene.wasToldToHideLoginNavigationAction)
    }
    
    func testTheWelcomePromptShouldBeSourcedUsingTheUser() {
        let user = User.random
        let context = NewsPresenterTestBuilder().withUser(user).build()
        context.simulateNewsSceneWillAppear()
        
        XCTAssertEqual(context.newsScene.capturedWelcomePrompt, .welcomePrompt(for: user))
    }
    
    func testTheWelcomeDescriptionShouldbeSourcedUsingTheUnreadMessageCount() {
        let context = NewsPresenterTestBuilder().withUser().build()
        context.simulateNewsSceneWillAppear()
        
        XCTAssertEqual("", context.newsScene.capturedWelcomeDescription)
    }
    
    func testWhenAuthServiceIndicatesUserLoggedOutTheSceneIsToldToShowTheLoginNavigationAction() {
        let context = NewsPresenterTestBuilder().withUser().build()
        context.authService.notifyObserversUserDidLogout()
        
        XCTAssertTrue(context.newsScene.wasToldToShowLoginNavigationAction)
    }
    
    func testWhenAuthServiceIndicatesUserLoggedOutTheSceneIsToldToHideTheMessagesNavigationAction() {
        let context = NewsPresenterTestBuilder().withUser().build()
        context.authService.notifyObserversUserDidLogout()
        
        XCTAssertTrue(context.newsScene.wasToldToHideMessagesNavigationAction)
    }
    
    func testWhenAuthServiceIndicatesUserLoggedOutTheNewsSceneIsToldToShowWelcomePrompt() {
        let context = NewsPresenterTestBuilder().withUser().build()
        context.authService.notifyObserversUserDidLogout()
        
        XCTAssertEqual(context.newsScene.capturedLoginPrompt, .anonymousUserLoginPrompt)
    }
    
    func testWhenTheShowMessagesActionIsTappedTheShowMessagesCommandIsRan() {
        let context = NewsPresenterTestBuilder().withUser().build()
        context.newsScene.tapShowMessagesAction()
        
        XCTAssertTrue(context.delegate.showPrivateMessagesRequested)
    }
    
    func testWhenPrivateMessagesReloadsTheUnreadCountDescriptionIsSetOntoTheScene() {
        let context = NewsPresenterTestBuilder().withUser().build()
        context.simulateNewsSceneWillAppear()
        let messageCount = Int.random
        context.privateMessagesService.notifyUnreadCountDidChange(to: messageCount)
        
        XCTAssertEqual(context.newsScene.capturedWelcomeDescription, .welcomeDescription(messageCount: messageCount))
    }
    
    func testUpdatingUnreadCountBeforeSceneAppearsDoesNotUpdateLabel() {
        let context = NewsPresenterTestBuilder().withUser().build()
        context.privateMessagesService.notifyUnreadCountDidChange(to: 0)
        
        XCTAssertNil(context.newsScene.capturedWelcomeDescription)
    }
    
}
