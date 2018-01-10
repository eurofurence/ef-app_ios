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
    private var completionHandler: ((PrivateMessagesRefreshResult) -> Void)?
    func refreshMessages(completionHandler: @escaping (PrivateMessagesRefreshResult) -> Void) {
        wasToldToRefreshMessages = true
        refreshMessagesCount += 1
        self.completionHandler = completionHandler
    }
    
    private var unreadMessageCountObservers = [PrivateMessagesServiceObserver]()
    func add(_ unreadMessageCountObserver: PrivateMessagesServiceObserver) {
        unreadMessageCountObservers.append(unreadMessageCountObserver)
    }
        
    func failLastRefresh() {
        unreadMessageCountObservers.forEach { $0.privateMessagesServiceDidFailToLoadMessages() }
    }
    
    func succeedLastRefresh(messages: [Message] = []) {
        unreadMessageCountObservers.forEach { $0.privateMessagesServiceDidFinishRefreshingMessages(messages) }
    }
    
    func notifyUnreadCountDidChange(to count: Int) {
        unreadMessageCountObservers.forEach { $0.privateMessagesServiceDidUpdateUnreadMessageCount(to: count) }
    }
    
}

class NewsPresenterTestsForLoggedInUser: XCTestCase {
    
    func testTheSceneIsToldToShowTheMessagesNavigationAction() {
        let context = NewsPresenterTestContext.makeTestCaseForAuthenticatedUser()
        XCTAssertTrue(context.newsScene.wasToldToShowMessagesNavigationAction)
    }
    
    func testTheSceneIsNotToldToShowTheLoginNavigationAction() {
        let context = NewsPresenterTestContext.makeTestCaseForAuthenticatedUser()
        XCTAssertFalse(context.newsScene.wasToldToShowLoginNavigationAction)
    }
    
    func testTheSceneIsToldToHideTheLoginNavigationAction() {
        let context = NewsPresenterTestContext.makeTestCaseForAuthenticatedUser()
        XCTAssertTrue(context.newsScene.wasToldToHideLoginNavigationAction)
    }
    
    func testTheSceneIsNotToldToHideTheMessagesNavigationAction() {
        let context = NewsPresenterTestContext.makeTestCaseForAuthenticatedUser()
        XCTAssertFalse(context.newsScene.wasToldToHideMessagesNavigationAction)
    }
    
    func testTheWelcomePromptShouldBeSourcedUsingTheUser() {
        let user = User(registrationNumber: 42, username: "User")
        let context = NewsPresenterTestContext.makeTestCaseForAuthenticatedUser(user)
        
        XCTAssertEqual(context.newsScene.capturedWelcomePrompt, .welcomePrompt(for: user))
    }
    
    func testTheWelcomeDescriptionShouldbeSourcedUsingTheUnreadMessageCount() {
        let context = NewsPresenterTestContext.makeTestCaseForAuthenticatedUser()
        
        XCTAssertEqual("", context.newsScene.capturedWelcomeDescription)
    }
    
    func testWhenAuthServiceIndicatesUserLoggedOutTheSceneIsToldToShowTheLoginNavigationAction() {
        let context = NewsPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.authService.notifyObserversUserDidLogout()
        
        XCTAssertTrue(context.newsScene.wasToldToShowLoginNavigationAction)
    }
    
    func testWhenAuthServiceIndicatesUserLoggedOutTheSceneIsToldToHideTheMessagesNavigationAction() {
        let context = NewsPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.authService.notifyObserversUserDidLogout()
        
        XCTAssertTrue(context.newsScene.wasToldToHideMessagesNavigationAction)
    }
    
    func testWhenAuthServiceIndicatesUserLoggedOutTheNewsSceneIsToldToShowWelcomePrompt() {
        let context = NewsPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.authService.notifyObserversUserDidLogout()
        
        XCTAssertEqual(context.newsScene.capturedLoginPrompt, .anonymousUserLoginPrompt)
    }
    
    func testWhenTheShowMessagesActionIsTappedTheShowMessagesCommandIsRan() {
        let context = NewsPresenterTestContext.makeTestCaseForAnonymousUser()
        context.newsScene.tapShowMessagesAction()
        
        XCTAssertTrue(context.delegate.showPrivateMessagesRequested)
    }
    
    func testTheShowMessagesCommandIsNotRanUntilTheShowMessagesActionIsTapped() {
        let context = NewsPresenterTestContext.makeTestCaseForAnonymousUser()
        XCTAssertFalse(context.delegate.showPrivateMessagesRequested)
    }
    
    func testWhenPrivateMessagesReloadsTheUnreadCountDescriptionIsSetOntoTheScene() {
        let privateMessagesService = CapturingPrivateMessagesService()
        let context = NewsPresenterTestContext.makeTestCaseForAuthenticatedUser(privateMessagesService: privateMessagesService)
        let messageCount = Int(arc4random())
        privateMessagesService.notifyUnreadCountDidChange(to: messageCount)
        
        XCTAssertEqual(context.newsScene.capturedWelcomeDescription, .welcomeDescription(messageCount: messageCount))
    }
    
    func testUpdatingUnreadCountBeforeSceneAppearsDoesNotUpdateLabel() {
        let privateMessagesService = CapturingPrivateMessagesService()
        let sceneFactory = StubNewsSceneFactory()
        _ = NewsModuleBuilder()
            .with(sceneFactory)
            .with(StubAuthenticationService(authState: .loggedIn(User(registrationNumber: 0, username: ""))))
            .with(privateMessagesService)
            .build()
            .makeNewsModule(CapturingNewsModuleDelegate())
        privateMessagesService.notifyUnreadCountDidChange(to: 0)
        
        XCTAssertNil(sceneFactory.stubbedScene.capturedWelcomeDescription)
    }
    
}
