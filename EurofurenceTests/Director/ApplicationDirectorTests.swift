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
    
    class ApplicationDirectorTestBuilder {
        
        struct Context {
            var director: ApplicationDirector
            var rootModuleFactory: StubRootModuleFactory
            var tutorialModuleFactory: StubTutorialModuleFactory
            var preloadModuleFactory: StubPreloadModuleFactory
            var tabModuleFactory: StubTabModuleFactory
            var newsModuleFactory: StubNewsModuleFactory
            var messagesModuleFactory: StubMessagesModuleFactory
            var loginModuleFactory: StubLoginModuleFactory
            var windowWireframe: CapturingWindowWireframe
            var messageDetailModuleFactory: StubMessageDetailModuleProviding
            var knowledgeListModuleProviding: StubKnowledgeListModuleProviding
            var knowledgeDetailModuleProviding: StubKnowledgeDetailModuleProviding
            var linkRouter: StubLinkRouter
            var webModuleProviding: StubWebMobuleProviding
            var urlOpener: CapturingURLOpener
            
            func navigateToTabController() {
                rootModuleFactory.delegate?.rootModuleDidDetermineStoreShouldRefresh()
                preloadModuleFactory.simulatePreloadFinished()
            }
            
            var rootNavigationController: UINavigationController {
                return windowWireframe.capturedRootInterface as! UINavigationController
            }
            
            func makeExpectedTabViewControllerRoots() -> [UIViewController] {
                return [newsModuleFactory.stubInterface, knowledgeListModuleProviding.stubInterface]
            }
            
            func rootNavigationTabControllers() -> [UINavigationController] {
                return tabModuleFactory.capturedTabModules.flatMap({ $0 as? UINavigationController })
            }
            
        }
        
        private let director: ApplicationDirector
        private let rootModuleFactory: StubRootModuleFactory
        private let tutorialModuleFactory: StubTutorialModuleFactory
        private let preloadModuleFactory: StubPreloadModuleFactory
        private let tabModuleFactory: StubTabModuleFactory
        private let newsModuleFactory: StubNewsModuleFactory
        private let messagesModuleFactory: StubMessagesModuleFactory
        private let loginModuleFactory: StubLoginModuleFactory
        private let windowWireframe: CapturingWindowWireframe
        private let messageDetailModuleFactory: StubMessageDetailModuleProviding
        private let knowledgeListModuleProviding: StubKnowledgeListModuleProviding
        private let knowledgeDetailModuleProviding: StubKnowledgeDetailModuleProviding
        private let linkRouter: StubLinkRouter
        private let webModuleProviding: StubWebMobuleProviding
        private let urlOpener: CapturingURLOpener
        
        init() {
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
        
        func build() -> Context {
            return Context(director: director,
                           rootModuleFactory: rootModuleFactory,
                           tutorialModuleFactory: tutorialModuleFactory,
                           preloadModuleFactory: preloadModuleFactory,
                           tabModuleFactory: tabModuleFactory,
                           newsModuleFactory: newsModuleFactory,
                           messagesModuleFactory: messagesModuleFactory,
                           loginModuleFactory: loginModuleFactory,
                           windowWireframe: windowWireframe,
                           messageDetailModuleFactory: messageDetailModuleFactory,
                           knowledgeListModuleProviding: knowledgeListModuleProviding,
                           knowledgeDetailModuleProviding: knowledgeDetailModuleProviding,
                           linkRouter: linkRouter,
                           webModuleProviding: webModuleProviding,
                           urlOpener: urlOpener)
        }
        
    }
    
    var context: ApplicationDirectorTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        context = ApplicationDirectorTestBuilder().build()
    }
    
    func testNavigationControllerSetAsRootOnWindow() {
        XCTAssertTrue(context.windowWireframe.capturedRootInterface is UINavigationController)
    }
    
    func testTheRootNavigationControllerDoesNotShowNavigationBar() {
        XCTAssertTrue(context.rootNavigationController.isNavigationBarHidden)
    }
    
    func testWhenRootModuleIndicatesUserNeedsToWitnessTutorialTheTutorialModuleIsSetOntoRootNavigationController() {
        context.rootModuleFactory.simulateTutorialShouldBePresented()
        XCTAssertEqual([context.tutorialModuleFactory.stubInterface], context.rootNavigationController.viewControllers)
    }
    
    func testWhenRootModuleIndicatesStoreShouldPreloadThePreloadModuleIsSetAsRoot() {
        context.rootModuleFactory.simulateStoreShouldBeRefreshed()
        XCTAssertEqual([context.preloadModuleFactory.stubInterface], context.rootNavigationController.viewControllers)
    }
    
    func testWhenTheTutorialFinishesThePreloadModuleIsSetAsRoot() {
        context.rootModuleFactory.simulateTutorialShouldBePresented()
        context.tutorialModuleFactory.simulateTutorialFinished()
        
        XCTAssertEqual([context.preloadModuleFactory.stubInterface], context.rootNavigationController.viewControllers)
    }
    
    func testWhenPreloadingFailsAfterFinishingTutorialTheTutorialIsRedisplayed() {
        context.rootModuleFactory.simulateTutorialShouldBePresented()
        context.tutorialModuleFactory.simulateTutorialFinished()
        context.preloadModuleFactory.simulatePreloadCancelled()
        
        XCTAssertEqual([context.tutorialModuleFactory.stubInterface], context.rootNavigationController.viewControllers)
    }
    
    func testWhenPreloadingSucceedsAfterFinishingTutorialTheTabWireframeIsSetAsTheRoot() {
        context.rootModuleFactory.simulateTutorialShouldBePresented()
        context.tutorialModuleFactory.simulateTutorialFinished()
        context.preloadModuleFactory.simulatePreloadFinished()
        
        XCTAssertEqual([context.tabModuleFactory.stubInterface], context.rootNavigationController.viewControllers)
    }
    
    func testWhenPresentingTabControllerTheDissolveTransitionIsUsed() {
        context.rootModuleFactory.simulateTutorialShouldBePresented()
        context.tutorialModuleFactory.simulateTutorialFinished()
        context.preloadModuleFactory.simulatePreloadFinished()
        let transition = context.rootNavigationController.delegate?.navigationController?(context.rootNavigationController, animationControllerFor: .push, from: context.preloadModuleFactory.stubInterface, to: context.tabModuleFactory.stubInterface)

        XCTAssertTrue(transition is ViewControllerDissolveTransitioning)
    }
    
    func testWhenShowingTheTheTabModuleItIsInitialisedWithControllersForTabModulesNestedInNavigationControllers() {
        context.navigateToTabController()
        let expected: [UIViewController] = context.makeExpectedTabViewControllerRoots()
        let actual = context.rootNavigationTabControllers().flatMap({ $0.topViewController })
        
        XCTAssertEqual(expected, actual)
    }
    
    func testWhenShowingTheTabModuleTheRootNavigationControllersUseTheTabItemsFromTheirRoots() {
        context.navigateToTabController()
        let expected: [UITabBarItem] = context.makeExpectedTabViewControllerRoots().map({ $0.tabBarItem })
        let actual: [UITabBarItem] = context.rootNavigationTabControllers().flatMap({ $0.tabBarItem })
        
        XCTAssertEqual(expected, actual)
    }
    
    func testWhenTheNewsModuleRequestsLoginTheMessagesControllerIsPushedOntoItsNavigationController() {
        context.navigateToTabController()
        let newsNavigationController = context.tabModuleFactory.navigationController(for: context.newsModuleFactory.stubInterface)
        context.newsModuleFactory.simulateLoginRequested()
        
        XCTAssertEqual(context.messagesModuleFactory.stubInterface, newsNavigationController?.pushedViewControllers.last)
    }
    
    func testWhenTheNewsModuleRequestsShowingPrivateMessagesTheMessagesControllerIsPushedOntoItsNavigationController() {
        context.navigateToTabController()
        let newsNavigationController = context.tabModuleFactory.navigationController(for: context.newsModuleFactory.stubInterface)
        context.newsModuleFactory.simulatePrivateMessagesDisplayRequested()
        
        XCTAssertEqual(context.messagesModuleFactory.stubInterface, newsNavigationController?.pushedViewControllers.last)
    }
    
    func testWhenTheMessagesModuleRequestsDismissalItIsDismissedFromTheTabController() {
        context.navigateToTabController()
        context.newsModuleFactory.simulatePrivateMessagesDisplayRequested()
        context.messagesModuleFactory.simulateDismissalRequested()
        
        XCTAssertTrue(context.tabModuleFactory.stubInterface.didDismissViewController)
    }
    
    func testWhenTheMessagesModuleRequestsDismissalTheNewsNavigationControllersPopsToTheNewsModule() {
        context.navigateToTabController()
        let newsNavigationController = context.tabModuleFactory.navigationController(for: context.newsModuleFactory.stubInterface)
        context.newsModuleFactory.simulatePrivateMessagesDisplayRequested()
        context.messagesModuleFactory.simulateDismissalRequested()
        
        XCTAssertEqual(context.newsModuleFactory.stubInterface, newsNavigationController?.viewControllerPoppedTo)
    }
    
    func testWhenTheMessagesModuleRequestsResolutionForUserTheLoginModuleIsPresentedOnTopOfTheTabController() {
        context.navigateToTabController()
        context.newsModuleFactory.simulatePrivateMessagesDisplayRequested()
        context.messagesModuleFactory.simulateResolutionForUser( { _ in })
        let navController = context.tabModuleFactory.stubInterface.capturedPresentedViewController as? UINavigationController
        
        XCTAssertEqual(navController?.topViewController, context.loginModuleFactory.stubInterface)
    }
    
    func testWhenTheMessagesModuleRequestsResolutionForUserTheLoginModuleIsPresentedUsingTheFormSheetModalPresentationStyle() {
        context.navigateToTabController()
        context.newsModuleFactory.simulatePrivateMessagesDisplayRequested()
        context.messagesModuleFactory.simulateResolutionForUser({ _ in })
        
        XCTAssertEqual(context.loginModuleFactory.stubInterface.modalPresentationStyle, .formSheet)
    }
    
    func testWhenShowingLoginForMessagesControllerWhenModuleCancelsLoginTheMessagesModuleIsToldResolutionFailed() {
        context.navigateToTabController()
        context.newsModuleFactory.simulatePrivateMessagesDisplayRequested()
        var userResolved = true
        context.messagesModuleFactory.simulateResolutionForUser({ userResolved = $0 })
        context.loginModuleFactory.simulateLoginCancelled()
        
        XCTAssertFalse(userResolved)
    }
    
    func testWhenShowingLoginForMessagesControllerTheMessagesModuleIsNotToldResolutionFailedBeforeLoginIsCancelled() {
        context.navigateToTabController()
        context.newsModuleFactory.simulatePrivateMessagesDisplayRequested()
        var userResolved = true
        context.messagesModuleFactory.simulateResolutionForUser({ userResolved = $0 })
        
        XCTAssertTrue(userResolved)
    }
    
    func testWhenShowingLoginForMessagesControllerWhenModuleLogsInTheMessagesModuleIsToldResolutionSucceeded() {
        context.navigateToTabController()
        context.newsModuleFactory.simulatePrivateMessagesDisplayRequested()
        var userResolved = false
        context.messagesModuleFactory.simulateResolutionForUser({ userResolved = $0 })
        context.loginModuleFactory.simulateLoginSucceeded()
        
        XCTAssertTrue(userResolved)
    }
    
    func testWhenShowingLoginForMessagesControllerTheMessagesModuleIsNotToldResolutionSucceededBeforeUserLogsIn() {
        context.navigateToTabController()
        context.newsModuleFactory.simulatePrivateMessagesDisplayRequested()
        var userResolved = false
        context.messagesModuleFactory.simulateResolutionForUser({ userResolved = $0 })
        
        XCTAssertFalse(userResolved)
    }
    
    func testWhenShowingLoginForMessagesControllerWhenLoginSucceedsItIsDismissed() {
        context.navigateToTabController()
        context.newsModuleFactory.simulatePrivateMessagesDisplayRequested()
        context.messagesModuleFactory.simulateResolutionForUser { (_) in }
        context.loginModuleFactory.simulateLoginSucceeded()
        
        XCTAssertTrue(context.tabModuleFactory.stubInterface.didDismissViewController)
    }
    
    func testWhenMessagesModuleRequestsPresentationForMessageTheMessageDetailModuleIsBuiltUsingChosenMessage() {
        context.navigateToTabController()
        context.newsModuleFactory.simulatePrivateMessagesDisplayRequested()
        let message = AppDataBuilder.makeMessage()
        context.messagesModuleFactory.simulateMessagePresentationRequested(message)
        
        XCTAssertEqual(message, context.messageDetailModuleFactory.capturedMessage)
    }
    
    func testWhenMessagesModuleRequestsPresentationForMessageTheMessageDetailModuleInterfaceIsPushedOntoMessagesNavigationController() {
        context.navigateToTabController()
        context.newsModuleFactory.simulatePrivateMessagesDisplayRequested()
        context.messagesModuleFactory.simulateMessagePresentationRequested(AppDataBuilder.makeMessage())
        let navigationController = context.messagesModuleFactory.stubInterface.navigationController
        
        XCTAssertEqual(context.messageDetailModuleFactory.stubInterface, navigationController?.topViewController)
    }
    
    func testWhenSelectingKnowledgeEntryTheKnowledgeEntryModuleIsPresented() {
        context.navigateToTabController()
        let knowledgeNavigationController = context.tabModuleFactory.navigationController(for: context.knowledgeListModuleProviding.stubInterface)
        let entry = KnowledgeEntry2.random
        context.knowledgeListModuleProviding.simulateKnowledgeEntrySelected(entry)
        
        XCTAssertEqual(context.knowledgeDetailModuleProviding.stubInterface, knowledgeNavigationController?.topViewController)
        XCTAssertEqual(entry, context.knowledgeDetailModuleProviding.capturedModel)
    }
    
    func testWhenKnowledgeEntrySelectsWebLinkTheWebModuleIsPresentedOntoTheTabInterface() {
        context.navigateToTabController()
        let entry = KnowledgeEntry2.random
        context.knowledgeListModuleProviding.simulateKnowledgeEntrySelected(entry)
        let link = entry.links.randomElement().element
        let url = URL.random
        context.linkRouter.stubbedLinkActions[link] = .web(url)
        context.knowledgeDetailModuleProviding.simulateLinkSelected(link)
        let webModuleForURL = context.webModuleProviding.producedWebModules[url]
        
        XCTAssertNotNil(webModuleForURL)
        XCTAssertEqual(webModuleForURL, context.tabModuleFactory.stubInterface.capturedPresentedViewController)
    }
    
    func testWhenKnowledgeEntrySelectsExternalAppLinkTheURLLauncherIsToldToHandleTheURL() {
        context.navigateToTabController()
        let entry = KnowledgeEntry2.random
        context.knowledgeListModuleProviding.simulateKnowledgeEntrySelected(entry)
        let link = entry.links.randomElement().element
        let url = URL.random
        context.linkRouter.stubbedLinkActions[link] = .externalURL(url)
        context.knowledgeDetailModuleProviding.simulateLinkSelected(link)
        
        XCTAssertEqual(url, context.urlOpener.capturedURLToOpen)
    }
    
}
