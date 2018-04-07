//
//  NewsPresenterTestsForLoggedInUser.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingPrivateMessagesService: PrivateMessagesService {
    
    var unreadMessageCount: Int = 0
    var localMessages: [Message] = []
    
    init(unreadMessageCount: Int = 0, localMessages: [Message] = []) {
        self.localMessages = localMessages
    }
    
    private(set) var wasToldToRefreshMessages = false
    private(set) var refreshMessagesCount = 0
    func refreshMessages() {
        wasToldToRefreshMessages = true
        refreshMessagesCount += 1
    }
    
    private var observers = [PrivateMessagesServiceObserver]()
    func add(_ observer: PrivateMessagesServiceObserver) {
        observers.append(observer)
    }
        
    func failLastRefresh() {
        observers.forEach { $0.privateMessagesServiceDidFailToLoadMessages() }
    }
    
    func succeedLastRefresh(messages: [Message] = []) {
        observers.forEach { $0.privateMessagesServiceDidFinishRefreshingMessages(messages) }
    }
    
    func notifyUnreadCountDidChange(to count: Int) {
        observers.forEach { $0.privateMessagesServiceDidUpdateUnreadMessageCount(to: count) }
    }
    
}

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
    
    func testTheSceneIsNotToldToHideTheMessagesNavigationAction() {
        let context = NewsPresenterTestBuilder().withUser().build()
        XCTAssertFalse(context.newsScene.wasToldToHideMessagesNavigationAction)
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
    
    func testTheShowMessagesCommandIsNotRanUntilTheShowMessagesActionIsTapped() {
        let context = NewsPresenterTestBuilder().withUser().build()
        XCTAssertFalse(context.delegate.showPrivateMessagesRequested)
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
