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
    
    var director: ApplicationDirector!
    var rootModuleFactory: StubRootModuleFactory!
    var tutorialModuleFactory: StubTutorialModuleFactory!
    var preloadModuleFactory: StubPreloadModuleFactory!
    var tabModuleFactory: StubTabModuleFactory!
    var newsModuleFactory: StubNewsModuleFactory!
    var messagesModuleFactory: StubMessagesModuleFactory!
    var loginModuleFactory: StubLoginModuleFactory!
    var windowWireframe: CapturingWindowWireframe!
    var messageDetailModuleFactory: StubMessageDetailModuleProviding!
    var knowledgeListModuleProviding: StubKnowledgeListModuleProviding!
    var knowledgeDetailModuleProviding: StubKnowledgeDetailModuleProviding!
    var linkRouter: StubLinkRouter!
    var webModuleProviding: StubWebMobuleProviding!
    var urlOpener: CapturingURLOpener!
    
    private func navigateToTabController() {
        rootModuleFactory.delegate?.rootModuleDidDetermineStoreShouldRefresh()
        preloadModuleFactory.delegate?.preloadModuleDidFinishPreloading()
    }
    
    private var rootNavigationController: UINavigationController {
        return windowWireframe.capturedRootInterface as! UINavigationController
    }
    
    private func makeExpectedTabViewControllerRoots() -> [UIViewController] {
        return [newsModuleFactory.stubInterface, knowledgeListModuleProviding.stubInterface]
    }
    
    private func rootNavigationTabControllers() -> [UINavigationController] {
        return tabModuleFactory.capturedTabModules.flatMap({ $0 as? UINavigationController })
    }
    
    override func setUp() {
        super.setUp()
        
        rootModuleFactory = StubRootModuleFactory()
        tutorialModuleFactory = StubTutorialModuleFactory()
        preloadModuleFactory = StubPreloadModuleFactory()
        windowWireframe = CapturingWindowWireframe()
        tabModuleFactory = StubTabModuleFactory()
        newsModuleFactory = StubNewsModuleFactory()
        messagesModuleFactory = StubMessagesModuleFactory()
        loginModuleFactory = StubLoginModuleFactory()
        messageDetailModuleFactory = StubMessageDetailModuleProviding()
        knowledgeListModuleProviding = StubKnowledgeListModuleProviding()
        knowledgeDetailModuleProviding = StubKnowledgeDetailModuleProviding()
        linkRouter = StubLinkRouter()
        webModuleProviding = StubWebMobuleProviding()
        urlOpener = CapturingURLOpener()
        
        let builder = DirectorBuilder()
        builder.withAnimations(false)
        builder.with(windowWireframe)
        builder.with(StubNavigationControllerFactory())
        builder.with(rootModuleFactory)
        builder.with(tutorialModuleFactory)
        builder.with(preloadModuleFactory)
        builder.with(tabModuleFactory)
        builder.with(newsModuleFactory)
        builder.with(messagesModuleFactory)
        builder.with(loginModuleFactory)
        builder.with(messageDetailModuleFactory)
        builder.with(knowledgeListModuleProviding)
        builder.with(knowledgeDetailModuleProviding)
        builder.with(linkRouter)
        builder.with(webModuleProviding)
        builder.with(urlOpener)
        
        director = builder.build()
    }
    
    func testNavigationControllerSetAsRootOnWindow() {
        XCTAssertTrue(windowWireframe.capturedRootInterface is UINavigationController)
    }
    
    func testTheRootNavigationControllerDoesNotShowNavigationBar() {
        XCTAssertTrue(rootNavigationController.isNavigationBarHidden)
    }
    
    func testWhenRootModuleIndicatesUserNeedsToWitnessTutorialTheTutorialModuleIsSetOntoRootNavigationController() {
        rootModuleFactory.delegate?.rootModuleDidDetermineTutorialShouldBePresented()
        XCTAssertEqual([tutorialModuleFactory.stubInterface], rootNavigationController.viewControllers)
    }
    
    func testWhenRootModuleIndicatesStoreShouldPreloadThePreloadModuleIsSetAsRoot() {
        rootModuleFactory.delegate?.rootModuleDidDetermineStoreShouldRefresh()
        XCTAssertEqual([preloadModuleFactory.stubInterface], rootNavigationController.viewControllers)
    }
    
    func testWhenTheTutorialFinishesThePreloadModuleIsSetAsRoot() {
        rootModuleFactory.delegate?.rootModuleDidDetermineTutorialShouldBePresented()
        tutorialModuleFactory.delegate?.tutorialModuleDidFinishPresentingTutorial()
        
        XCTAssertEqual([preloadModuleFactory.stubInterface], rootNavigationController.viewControllers)
    }
    
    func testWhenPreloadingFailsAfterFinishingTutorialTheTutorialIsRedisplayed() {
        rootModuleFactory.delegate?.rootModuleDidDetermineTutorialShouldBePresented()
        tutorialModuleFactory.delegate?.tutorialModuleDidFinishPresentingTutorial()
        preloadModuleFactory.delegate?.preloadModuleDidCancelPreloading()
        
        XCTAssertEqual([tutorialModuleFactory.stubInterface], rootNavigationController.viewControllers)
    }
    
    func testWhenPreloadingSucceedsAfterFinishingTutorialTheTabWireframeIsSetAsTheRoot() {
        rootModuleFactory.delegate?.rootModuleDidDetermineTutorialShouldBePresented()
        tutorialModuleFactory.delegate?.tutorialModuleDidFinishPresentingTutorial()
        preloadModuleFactory.delegate?.preloadModuleDidFinishPreloading()
        
        XCTAssertEqual([tabModuleFactory.stubInterface], rootNavigationController.viewControllers)
    }
    
    func testWhenPresentingTabControllerTheDissolveTransitionIsUsed() {
        rootModuleFactory.delegate?.rootModuleDidDetermineTutorialShouldBePresented()
        tutorialModuleFactory.delegate?.tutorialModuleDidFinishPresentingTutorial()
        preloadModuleFactory.delegate?.preloadModuleDidFinishPreloading()
        let transition = rootNavigationController.delegate?.navigationController?(rootNavigationController, animationControllerFor: .push, from: preloadModuleFactory.stubInterface, to: tabModuleFactory.stubInterface)

        XCTAssertTrue(transition is ViewControllerDissolveTransitioning)
    }
    
    func testWhenShowingTheTheTabModuleItIsInitialisedWithControllersForTabModulesNestedInNavigationControllers() {
        navigateToTabController()
        let expected: [UIViewController] = makeExpectedTabViewControllerRoots()
        let actual = rootNavigationTabControllers().flatMap({ $0.topViewController })
        
        XCTAssertEqual(expected, actual)
    }
    
    func testWhenShowingTheTabModuleTheRootNavigationControllersUseTheTabItemsFromTheirRoots() {
        navigateToTabController()
        let expected: [UITabBarItem] = makeExpectedTabViewControllerRoots().map({ $0.tabBarItem })
        let actual: [UITabBarItem] = rootNavigationTabControllers().flatMap({ $0.tabBarItem })
        
        XCTAssertEqual(expected, actual)
    }
    
    func testWhenTheNewsModuleRequestsLoginTheMessagesControllerIsPushedOntoItsNavigationController() {
        navigateToTabController()
        let newsNavigationController = tabModuleFactory.navigationController(for: newsModuleFactory.stubInterface)
        newsModuleFactory.delegate?.newsModuleDidRequestLogin()
        
        XCTAssertEqual(messagesModuleFactory.stubInterface, newsNavigationController?.pushedViewControllers.last)
    }
    
    func testWhenTheNewsModuleRequestsShowingPrivateMessagesTheMessagesControllerIsPushedOntoItsNavigationController() {
        navigateToTabController()
        let newsNavigationController = tabModuleFactory.navigationController(for: newsModuleFactory.stubInterface)
        newsModuleFactory.delegate?.newsModuleDidRequestShowingPrivateMessages()
        
        XCTAssertEqual(messagesModuleFactory.stubInterface, newsNavigationController?.pushedViewControllers.last)
    }
    
    func testWhenTheMessagesModuleRequestsDismissalItIsDismissedFromTheTabController() {
        navigateToTabController()
        newsModuleFactory.delegate?.newsModuleDidRequestShowingPrivateMessages()
        messagesModuleFactory.delegate?.messagesModuleDidRequestDismissal()
        
        XCTAssertTrue(tabModuleFactory.stubInterface.didDismissViewController)
    }
    
    func testWhenTheMessagesModuleRequestsDismissalTheNewsNavigationControllersPopsToTheNewsModule() {
        navigateToTabController()
        let newsNavigationController = tabModuleFactory.navigationController(for: newsModuleFactory.stubInterface)
        newsModuleFactory.delegate?.newsModuleDidRequestShowingPrivateMessages()
        messagesModuleFactory.delegate?.messagesModuleDidRequestDismissal()
        
        XCTAssertEqual(newsModuleFactory.stubInterface, newsNavigationController?.viewControllerPoppedTo)
    }
    
    func testWhenTheMessagesModuleRequestsResolutionForUserTheLoginModuleIsPresentedOnTopOfTheTabController() {
        navigateToTabController()
        newsModuleFactory.delegate?.newsModuleDidRequestShowingPrivateMessages()
        messagesModuleFactory.delegate?.messagesModuleDidRequestResolutionForUser(completionHandler: { _ in })
        let navController = tabModuleFactory.stubInterface.capturedPresentedViewController as? UINavigationController
        
        XCTAssertEqual(navController?.topViewController, loginModuleFactory.stubInterface)
    }
    
    func testWhenTheMessagesModuleRequestsResolutionForUserTheLoginModuleIsPresentedUsingTheFormSheetModalPresentationStyle() {
        navigateToTabController()
        newsModuleFactory.delegate?.newsModuleDidRequestShowingPrivateMessages()
        messagesModuleFactory.delegate?.messagesModuleDidRequestResolutionForUser(completionHandler: { _ in })
        
        XCTAssertEqual(loginModuleFactory.stubInterface.modalPresentationStyle, .formSheet)
    }
    
    func testWhenShowingLoginForMessagesControllerWhenModuleCancelsLoginTheMessagesModuleIsToldResolutionFailed() {
        navigateToTabController()
        newsModuleFactory.delegate?.newsModuleDidRequestShowingPrivateMessages()
        var userResolved = true
        messagesModuleFactory.delegate?.messagesModuleDidRequestResolutionForUser(completionHandler: { userResolved = $0 })
        loginModuleFactory.delegate?.loginModuleDidCancelLogin()
        
        XCTAssertFalse(userResolved)
    }
    
    func testWhenShowingLoginForMessagesControllerTheMessagesModuleIsNotToldResolutionFailedBeforeLoginIsCancelled() {
        navigateToTabController()
        newsModuleFactory.delegate?.newsModuleDidRequestShowingPrivateMessages()
        var userResolved = true
        messagesModuleFactory.delegate?.messagesModuleDidRequestResolutionForUser(completionHandler: { userResolved = $0 })
        
        XCTAssertTrue(userResolved)
    }
    
    func testWhenShowingLoginForMessagesControllerWhenModuleLogsInTheMessagesModuleIsToldResolutionSucceeded() {
        navigateToTabController()
        newsModuleFactory.delegate?.newsModuleDidRequestShowingPrivateMessages()
        var userResolved = false
        messagesModuleFactory.delegate?.messagesModuleDidRequestResolutionForUser(completionHandler: { userResolved = $0 })
        loginModuleFactory.delegate?.loginModuleDidLoginSuccessfully()
        
        XCTAssertTrue(userResolved)
    }
    
    func testWhenShowingLoginForMessagesControllerTheMessagesModuleIsNotToldResolutionSucceededBeforeUserLogsIn() {
        navigateToTabController()
        newsModuleFactory.delegate?.newsModuleDidRequestShowingPrivateMessages()
        var userResolved = false
        messagesModuleFactory.delegate?.messagesModuleDidRequestResolutionForUser(completionHandler: { userResolved = $0 })
        
        XCTAssertFalse(userResolved)
    }
    
    func testWhenShowingLoginForMessagesControllerWhenLoginSucceedsItIsDismissed() {
        navigateToTabController()
        newsModuleFactory.delegate?.newsModuleDidRequestShowingPrivateMessages()
        messagesModuleFactory.delegate?.messagesModuleDidRequestResolutionForUser { (_) in }
        loginModuleFactory.delegate?.loginModuleDidLoginSuccessfully()
        
        XCTAssertTrue(tabModuleFactory.stubInterface.didDismissViewController)
    }
    
    func testWhenMessagesModuleRequestsPresentationForMessageTheMessageDetailModuleIsBuiltUsingChosenMessage() {
        navigateToTabController()
        newsModuleFactory.delegate?.newsModuleDidRequestShowingPrivateMessages()
        let message = AppDataBuilder.makeMessage()
        messagesModuleFactory.delegate?.messagesModuleDidRequestPresentation(for: message)
        
        XCTAssertEqual(message, messageDetailModuleFactory.capturedMessage)
    }
    
    func testWhenMessagesModuleRequestsPresentationForMessageTheMessageDetailModuleInterfaceIsPushedOntoMessagesNavigationController() {
        navigateToTabController()
        newsModuleFactory.delegate?.newsModuleDidRequestShowingPrivateMessages()
        messagesModuleFactory.delegate?.messagesModuleDidRequestPresentation(for: AppDataBuilder.makeMessage())
        let navigationController = messagesModuleFactory.stubInterface.navigationController
        
        XCTAssertEqual(messageDetailModuleFactory.stubInterface, navigationController?.topViewController)
    }
    
    func testWhenSelectingKnowledgeEntryTheKnowledgeEntryModuleIsPresented() {
        navigateToTabController()
        let knowledgeNavigationController = tabModuleFactory.navigationController(for: knowledgeListModuleProviding.stubInterface)
        let entry = KnowledgeEntry2.random
        knowledgeListModuleProviding.delegate?.knowledgeListModuleDidSelectKnowledgeEntry(entry)
        
        XCTAssertEqual(knowledgeDetailModuleProviding.stubInterface, knowledgeNavigationController?.topViewController)
        XCTAssertEqual(entry, knowledgeDetailModuleProviding.capturedModel)
    }
    
    func testWhenKnowledgeEntrySelectsWebLinkTheWebModuleIsPresentedOntoTheTabInterface() {
        navigateToTabController()
        let entry = KnowledgeEntry2.random
        knowledgeListModuleProviding.delegate?.knowledgeListModuleDidSelectKnowledgeEntry(entry)
        let link = entry.links.randomElement().element
        let url = URL.random
        linkRouter.stubbedLinkActions[link] = .web(url)
        knowledgeDetailModuleProviding.delegate?.knowledgeDetailModuleDidSelectLink(link)
        let webModuleForURL = webModuleProviding.producedWebModules[url]
        
        XCTAssertNotNil(webModuleForURL)
        XCTAssertEqual(webModuleForURL, tabModuleFactory.stubInterface.capturedPresentedViewController)
    }
    
    func testWhenKnowledgeEntrySelectsExternalAppLinkTheURLLauncherIsToldToHandleTheURL() {
        navigateToTabController()
        let entry = KnowledgeEntry2.random
        knowledgeListModuleProviding.delegate?.knowledgeListModuleDidSelectKnowledgeEntry(entry)
        let link = entry.links.randomElement().element
        let url = URL.random
        linkRouter.stubbedLinkActions[link] = .externalURL(url)
        knowledgeDetailModuleProviding.delegate?.knowledgeDetailModuleDidSelectLink(link)
        
        XCTAssertEqual(url, urlOpener.capturedURLToOpen)
    }
    
}
