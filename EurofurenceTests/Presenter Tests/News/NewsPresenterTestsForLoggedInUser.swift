//
//  NewsPresenterTestsForLoggedInUser.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

struct StubPrivateMessagesService: PrivateMessagesService {
    
    init(unreadMessageCount: Int = 0, localMessages: [Message] = []) {
        self.unreadMessageCount = unreadMessageCount
        self.localMessages = localMessages
    }
    
    var unreadMessageCount: Int = 0
    var localMessages: [Message] = []
    
    func refreshMessages(completionHandler: @escaping (PrivateMessagesRefreshResult) -> Void) { }
    
}

class CapturingPrivateMessagesService: PrivateMessagesService {
    
    var unreadMessageCount: Int = 0
    var localMessages: [Message] = []
    
    init(localMessages: [Message] = []) {
        self.localMessages = localMessages
    }
    
    private(set) var wasToldToRefreshMessages = false
    private var completionHandler: ((PrivateMessagesRefreshResult) -> Void)?
    func refreshMessages(completionHandler: @escaping (PrivateMessagesRefreshResult) -> Void) {
        wasToldToRefreshMessages = true
        self.completionHandler = completionHandler
    }
    
    func failLastRefresh() {
        completionHandler?(.failure)
    }
    
    func succeedLastRefresh(messages: [Message] = []) {
        completionHandler?(.success(messages))
    }
    
}

struct DummyPrivateMessagesService: PrivateMessagesService {
    
    var unreadMessageCount: Int = 0
    var localMessages: [Message] = []
    
    func refreshMessages(completionHandler: @escaping (PrivateMessagesRefreshResult) -> Void) { }
    
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
    
    func testTheWelcomePromptStringFactoryShouldGeneratePromptUsingLoggedInUser() {
        let user = User(registrationNumber: 42, username: "Cool dude")
        let welcomePromptStringFactory = CapturingWelcomePromptStringFactory()
        NewsPresenterTestContext.makeTestCaseForAuthenticatedUser(user, welcomePromptStringFactory: welcomePromptStringFactory)
        
        XCTAssertEqual(user, welcomePromptStringFactory.capturedWelcomePromptUser)
    }
    
    func testTheWelcomePromptStringFactoryShouldGenerateDescriptionUsingUnreadMessageCount() {
        let unreadCount = Random.makeRandomNumber()
        let welcomePromptStringFactory = CapturingWelcomePromptStringFactory()
        let privateMessagesService = StubPrivateMessagesService(unreadMessageCount: unreadCount)
        NewsPresenterTestContext.makeTestCaseForAuthenticatedUser(welcomePromptStringFactory: welcomePromptStringFactory, privateMessagesService: privateMessagesService)
        
        XCTAssertEqual(unreadCount, welcomePromptStringFactory.capturedUnreadMessageCount)
    }
    
    func testTheWelcomePromptShouldBeSourcedFromTheWelcomePromptStringFactory() {
        let expected = "Welcome to the world of tomorrow"
        let welcomePromptStringFactory = CapturingWelcomePromptStringFactory()
        welcomePromptStringFactory.stubbedUserString = expected
        let context = NewsPresenterTestContext.makeTestCaseForAuthenticatedUser(welcomePromptStringFactory: welcomePromptStringFactory)
        
        XCTAssertEqual(expected, context.newsScene.capturedWelcomePrompt)
    }
    
    func testTheWelcomeDescriptionShouldbeSourcedFromTheWelcomePromptStringFactory() {
        let expected = "You have a bunch of unread mail"
        let welcomePromptStringFactory = CapturingWelcomePromptStringFactory()
        welcomePromptStringFactory.stubbedUnreadMessageString = expected
        let context = NewsPresenterTestContext.makeTestCaseForAuthenticatedUser(welcomePromptStringFactory: welcomePromptStringFactory)
        
        XCTAssertEqual(expected, context.newsScene.capturedWelcomeDescription)
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
    
    func testWhenAuthServiceIndicatesUserLoggedOutTheNewsSceneIsToldToShowWelcomePromptWithLoginHintFromStringFactory() {
        let expected = "You should totes login"
        let welcomePromptStringFactory = CapturingWelcomePromptStringFactory()
        welcomePromptStringFactory.stubbedLoginString = expected
        let context = NewsPresenterTestContext.makeTestCaseForAuthenticatedUser(welcomePromptStringFactory: welcomePromptStringFactory)
        context.authService.notifyObserversUserDidLogout()
        
        XCTAssertEqual(expected, context.newsScene.capturedLoginPrompt)
    }
    
    func testWhenTheShowMessagesActionIsTappedTheShowMessagesCommandIsRan() {
        let context = NewsPresenterTestContext.makeTestCaseForAnonymousUser()
        context.newsScene.tapShowMessagesAction()
        
        XCTAssertTrue(context.showMessagesCommand.wasRan)
    }
    
    func testTheShowMessagesCommandIsNotRanUntilTheShowMessagesActionIsTapped() {
        let context = NewsPresenterTestContext.makeTestCaseForAnonymousUser()
        XCTAssertFalse(context.showMessagesCommand.wasRan)
    }
    
}
