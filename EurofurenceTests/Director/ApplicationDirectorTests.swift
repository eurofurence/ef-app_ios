//
//  ApplicationDirectorTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class ApplicationDirectorTests: XCTestCase {
    
    var context: ApplicationDirectorTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        context = ApplicationDirectorTestBuilder().build()
    }
    
    func testWhenTheNewsModuleRequestsLoginTheMessagesControllerIsPushedOntoItsNavigationController() {
        context.navigateToTabController()
        let newsNavigationController = context.navigationController(for: context.newsModule.stubInterface)
        context.newsModule.simulateLoginRequested()
        
        XCTAssertEqual(context.messages.stubInterface, newsNavigationController?.pushedViewControllers.last)
    }
    
    func testWhenTheMessagesModuleRequestsResolutionForUserTheLoginModuleIsPresentedOnTopOfTheTabController() {
        context.navigateToTabController()
        context.newsModule.simulatePrivateMessagesDisplayRequested()
        context.messages.simulateResolutionForUser( { _ in })
        let navController = context.tabModule.stubInterface.capturedPresentedViewController as? UINavigationController
        
        XCTAssertEqual(navController?.topViewController, context.loginModule.stubInterface)
    }
    
    func testWhenTheMessagesModuleRequestsResolutionForUserTheLoginModuleIsPresentedUsingTheFormSheetModalPresentationStyle() {
        context.navigateToTabController()
        context.newsModule.simulatePrivateMessagesDisplayRequested()
        context.messages.simulateResolutionForUser({ _ in })
        
        XCTAssertEqual(context.loginModule.stubInterface.modalPresentationStyle, .formSheet)
    }
    
    func testWhenShowingLoginForMessagesControllerWhenModuleCancelsLoginTheMessagesModuleIsToldResolutionFailed() {
        context.navigateToTabController()
        context.newsModule.simulatePrivateMessagesDisplayRequested()
        var userResolved = true
        context.messages.simulateResolutionForUser({ userResolved = $0 })
        context.loginModule.simulateLoginCancelled()
        
        XCTAssertFalse(userResolved)
    }
    
    func testWhenShowingLoginForMessagesControllerTheMessagesModuleIsNotToldResolutionFailedBeforeLoginIsCancelled() {
        context.navigateToTabController()
        context.newsModule.simulatePrivateMessagesDisplayRequested()
        var userResolved = true
        context.messages.simulateResolutionForUser({ userResolved = $0 })
        
        XCTAssertTrue(userResolved)
    }
    
    func testWhenShowingLoginForMessagesControllerWhenModuleLogsInTheMessagesModuleIsToldResolutionSucceeded() {
        context.navigateToTabController()
        context.newsModule.simulatePrivateMessagesDisplayRequested()
        var userResolved = false
        context.messages.simulateResolutionForUser({ userResolved = $0 })
        context.loginModule.simulateLoginSucceeded()
        
        XCTAssertTrue(userResolved)
    }
    
    func testWhenShowingLoginForMessagesControllerTheMessagesModuleIsNotToldResolutionSucceededBeforeUserLogsIn() {
        context.navigateToTabController()
        context.newsModule.simulatePrivateMessagesDisplayRequested()
        var userResolved = false
        context.messages.simulateResolutionForUser({ userResolved = $0 })
        
        XCTAssertFalse(userResolved)
    }
    
    func testWhenShowingLoginForMessagesControllerWhenLoginSucceedsItIsDismissed() {
        context.navigateToTabController()
        context.newsModule.simulatePrivateMessagesDisplayRequested()
        context.messages.simulateResolutionForUser { (_) in }
        context.loginModule.simulateLoginSucceeded()
        
        XCTAssertTrue(context.tabModule.stubInterface.didDismissViewController)
    }
    
    func testWhenMessagesModuleRequestsPresentationForMessageTheMessageDetailModuleIsBuiltUsingChosenMessage() {
        context.navigateToTabController()
        context.newsModule.simulatePrivateMessagesDisplayRequested()
        let message = AppDataBuilder.makeMessage()
        context.messages.simulateMessagePresentationRequested(message)
        
        XCTAssertEqual(message, context.messageDetailModule.capturedMessage)
    }
    
    func testWhenMessagesModuleRequestsPresentationForMessageTheMessageDetailModuleInterfaceIsPushedOntoMessagesNavigationController() {
        context.navigateToTabController()
        context.newsModule.simulatePrivateMessagesDisplayRequested()
        context.messages.simulateMessagePresentationRequested(AppDataBuilder.makeMessage())
        let navigationController = context.messages.stubInterface.navigationController
        
        XCTAssertEqual(context.messageDetailModule.stubInterface, navigationController?.topViewController)
    }
    
    func testWhenSelectingKnowledgeEntryTheKnowledgeEntryModuleIsPresented() {
        context.navigateToTabController()
        let knowledgeNavigationController = context.navigationController(for: context.knowledgeListModule.stubInterface)
        let entry = KnowledgeEntry2.random
        context.knowledgeListModule.simulateKnowledgeEntrySelected(entry)
        
        XCTAssertEqual(context.knowledgeDetailModule.stubInterface, knowledgeNavigationController?.topViewController)
        XCTAssertEqual(entry, context.knowledgeDetailModule.capturedModel)
    }
    
    func testWhenKnowledgeEntrySelectsWebLinkTheWebModuleIsPresentedOntoTheTabInterface() {
        context.navigateToTabController()
        let entry = KnowledgeEntry2.random
        context.knowledgeListModule.simulateKnowledgeEntrySelected(entry)
        let link = entry.links.randomElement().element
        let url = URL.random
        context.linkRouter.stubbedLinkActions[link] = .web(url)
        context.knowledgeDetailModule.simulateLinkSelected(link)
        let webModuleForURL = context.webModuleProviding.producedWebModules[url]
        
        XCTAssertNotNil(webModuleForURL)
        XCTAssertEqual(webModuleForURL, context.tabModule.stubInterface.capturedPresentedViewController)
    }
    
    func testWhenKnowledgeEntrySelectsExternalAppLinkTheURLLauncherIsToldToHandleTheURL() {
        context.navigateToTabController()
        let entry = KnowledgeEntry2.random
        context.knowledgeListModule.simulateKnowledgeEntrySelected(entry)
        let link = entry.links.randomElement().element
        let url = URL.random
        context.linkRouter.stubbedLinkActions[link] = .externalURL(url)
        context.knowledgeDetailModule.simulateLinkSelected(link)
        
        XCTAssertEqual(url, context.urlOpener.capturedURLToOpen)
    }
    
}
