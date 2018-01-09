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
    
    func add(_ unreadMessageCountObserver: PrivateMessageUnreadCountObserver) { }
    func refreshMessages(completionHandler: @escaping (PrivateMessagesRefreshResult) -> Void) { }
    
}

class CapturingPrivateMessagesService: PrivateMessagesService {
    
    var unreadMessageCount: Int = 0
    var localMessages: [Message] = []
    
    init(localMessages: [Message] = []) {
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
    
    private var unreadMessageCountObservers = [PrivateMessageUnreadCountObserver]()
    func add(_ unreadMessageCountObserver: PrivateMessageUnreadCountObserver) {
        unreadMessageCountObservers.append(unreadMessageCountObserver)
    }
    
    func failLastRefresh() {
        completionHandler?(.failure)
    }
    
    func succeedLastRefresh(messages: [Message] = []) {
        completionHandler?(.success(messages))
    }
    
    func notifyUnreadCountDidChange(to count: Int) {
        unreadMessageCountObservers.forEach { $0.unreadPrivateMessagesCountDidChange(to: count) }
    }
    
}

struct DummyPrivateMessagesService: PrivateMessagesService {
    
    var unreadMessageCount: Int = 0
    var localMessages: [Message] = []
    
    func refreshMessages(completionHandler: @escaping (PrivateMessagesRefreshResult) -> Void) { }
    func add(_ unreadMessageCountObserver: PrivateMessageUnreadCountObserver) { }
    
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
    
    func testWhenPrivateMessagesReloadsTheUpdatedCountIsUsedToMakeNewWelcomeDescription() {
        let privateMessagesService = CapturingPrivateMessagesService()
        let welcomePromptStringFactory = CapturingWelcomePromptStringFactory()
        _ = NewsPresenterTestContext.makeTestCaseForAuthenticatedUser(welcomePromptStringFactory: welcomePromptStringFactory, privateMessagesService: privateMessagesService)
        let unreadCount = Random.makeRandomNumber()
        privateMessagesService.notifyUnreadCountDidChange(to: unreadCount)
        
        XCTAssertEqual(unreadCount, welcomePromptStringFactory.capturedUnreadMessageCount)
    }
    
    func testWhenPrivateMessagesReloadsTheUnreadCountDescriptionIsSetOntoTheScene() {
        let expected = "You got a buncha messages!"
        let privateMessagesService = CapturingPrivateMessagesService()
        let welcomePromptStringFactory = CapturingWelcomePromptStringFactory()
        let context = NewsPresenterTestContext.makeTestCaseForAuthenticatedUser(welcomePromptStringFactory: welcomePromptStringFactory, privateMessagesService: privateMessagesService)
        welcomePromptStringFactory.stubbedUnreadMessageString = expected
        privateMessagesService.notifyUnreadCountDidChange(to: 0)
        
        XCTAssertEqual(expected, context.newsScene.capturedWelcomeDescription)
    }
    
    func testUpdatingUnreadCountBeforeSceneAppearsDoesNotUpdateLabel() {
        let expected = "You got a buncha messages!"
        let privateMessagesService = CapturingPrivateMessagesService()
        let welcomePromptStringFactory = CapturingWelcomePromptStringFactory()
        let sceneFactory = StubNewsSceneFactory()
        _ = NewsModuleBuilder()
            .with(sceneFactory)
            .with(StubAuthenticationService(authState: .loggedIn(User(registrationNumber: 0, username: ""))))
            .with(privateMessagesService)
            .with(welcomePromptStringFactory)
            .build()
            .makeNewsModule(CapturingNewsModuleDelegate())
        welcomePromptStringFactory.stubbedUnreadMessageString = expected
        privateMessagesService.notifyUnreadCountDidChange(to: 0)
        
        XCTAssertNotEqual(expected, sceneFactory.stubbedScene.capturedWelcomeDescription)
    }
    
}
