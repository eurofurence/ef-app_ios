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
            var rootModule: StubRootModuleFactory
            var tutorialModule: StubTutorialModuleFactory
            var preloadModule: StubPreloadModuleFactory
            var tabModule: StubTabModuleFactory
            var newsModule: StubNewsModuleFactory
            var messages: StubMessagesModuleFactory
            var loginModule: StubLoginModuleFactory
            var windowWireframe: CapturingWindowWireframe
            var messageDetailModule: StubMessageDetailModuleProviding
            var knowledgeListModule: StubKnowledgeListModuleProviding
            var knowledgeDetailModule: StubKnowledgeDetailModuleProviding
            var linkRouter: StubLinkRouter
            var webModuleProviding: StubWebMobuleProviding
            var urlOpener: CapturingURLOpener
            
            func navigateToTabController() {
                rootModule.delegate?.rootModuleDidDetermineStoreShouldRefresh()
                preloadModule.simulatePreloadFinished()
            }
            
            var rootNavigationController: UINavigationController {
                return windowWireframe.capturedRootInterface as! UINavigationController
            }
            
            func makeExpectedTabViewControllerRoots() -> [UIViewController] {
                return [newsModule.stubInterface, knowledgeListModule.stubInterface]
            }
            
            func rootNavigationTabControllers() -> [UINavigationController] {
                return tabModule.capturedTabModules.flatMap({ $0 as? UINavigationController })
            }
            
            func navigationController(for viewController: UIViewController) -> CapturingNavigationController? {
                return tabModule.navigationController(for: viewController)
            }
            
        }
        
        private let director: ApplicationDirector
        private let rootModule: StubRootModuleFactory
        private let tutorialModule: StubTutorialModuleFactory
        private let preloadModule: StubPreloadModuleFactory
        private let tabModule: StubTabModuleFactory
        private let newsModule: StubNewsModuleFactory
        private let messagesModule: StubMessagesModuleFactory
        private let loginModule: StubLoginModuleFactory
        private let windowWireframe: CapturingWindowWireframe
        private let messageDetailModule: StubMessageDetailModuleProviding
        private let knowledgeListModule: StubKnowledgeListModuleProviding
        private let knowledgeDetailModule: StubKnowledgeDetailModuleProviding
        private let linkRouter: StubLinkRouter
        private let webModuleProviding: StubWebMobuleProviding
        private let urlOpener: CapturingURLOpener
        
        init() {
            rootModule = StubRootModuleFactory()
            tutorialModule = StubTutorialModuleFactory()
            preloadModule = StubPreloadModuleFactory()
            windowWireframe = CapturingWindowWireframe()
            tabModule = StubTabModuleFactory()
            newsModule = StubNewsModuleFactory()
            messagesModule = StubMessagesModuleFactory()
            loginModule = StubLoginModuleFactory()
            messageDetailModule = StubMessageDetailModuleProviding()
            knowledgeListModule = StubKnowledgeListModuleProviding()
            knowledgeDetailModule = StubKnowledgeDetailModuleProviding()
            linkRouter = StubLinkRouter()
            webModuleProviding = StubWebMobuleProviding()
            urlOpener = CapturingURLOpener()
            
            let builder = DirectorBuilder()
            builder.withAnimations(false)
            builder.with(windowWireframe)
            builder.with(StubNavigationControllerFactory())
            builder.with(rootModule)
            builder.with(tutorialModule)
            builder.with(preloadModule)
            builder.with(tabModule)
            builder.with(newsModule)
            builder.with(messagesModule)
            builder.with(loginModule)
            builder.with(messageDetailModule)
            builder.with(knowledgeListModule)
            builder.with(knowledgeDetailModule)
            builder.with(linkRouter)
            builder.with(webModuleProviding)
            builder.with(urlOpener)
            
            director = builder.build()
        }
        
        func build() -> Context {
            return Context(director: director,
                           rootModule: rootModule,
                           tutorialModule: tutorialModule,
                           preloadModule: preloadModule,
                           tabModule: tabModule,
                           newsModule: newsModule,
                           messages: messagesModule,
                           loginModule: loginModule,
                           windowWireframe: windowWireframe,
                           messageDetailModule: messageDetailModule,
                           knowledgeListModule: knowledgeListModule,
                           knowledgeDetailModule: knowledgeDetailModule,
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
        context.rootModule.simulateTutorialShouldBePresented()
        XCTAssertEqual([context.tutorialModule.stubInterface], context.rootNavigationController.viewControllers)
    }
    
    func testWhenRootModuleIndicatesStoreShouldPreloadThePreloadModuleIsSetAsRoot() {
        context.rootModule.simulateStoreShouldBeRefreshed()
        XCTAssertEqual([context.preloadModule.stubInterface], context.rootNavigationController.viewControllers)
    }
    
    func testWhenTheTutorialFinishesThePreloadModuleIsSetAsRoot() {
        context.rootModule.simulateTutorialShouldBePresented()
        context.tutorialModule.simulateTutorialFinished()
        
        XCTAssertEqual([context.preloadModule.stubInterface], context.rootNavigationController.viewControllers)
    }
    
    func testWhenPreloadingFailsAfterFinishingTutorialTheTutorialIsRedisplayed() {
        context.rootModule.simulateTutorialShouldBePresented()
        context.tutorialModule.simulateTutorialFinished()
        context.preloadModule.simulatePreloadCancelled()
        
        XCTAssertEqual([context.tutorialModule.stubInterface], context.rootNavigationController.viewControllers)
    }
    
    func testWhenPreloadingSucceedsAfterFinishingTutorialTheTabWireframeIsSetAsTheRoot() {
        context.rootModule.simulateTutorialShouldBePresented()
        context.tutorialModule.simulateTutorialFinished()
        context.preloadModule.simulatePreloadFinished()
        
        XCTAssertEqual([context.tabModule.stubInterface], context.rootNavigationController.viewControllers)
    }
    
    func testWhenPresentingTabControllerTheDissolveTransitionIsUsed() {
        context.rootModule.simulateTutorialShouldBePresented()
        context.tutorialModule.simulateTutorialFinished()
        context.preloadModule.simulatePreloadFinished()
        let transition = context.rootNavigationController.delegate?.navigationController?(context.rootNavigationController, animationControllerFor: .push, from: context.preloadModule.stubInterface, to: context.tabModule.stubInterface)

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
        let newsNavigationController = context.navigationController(for: context.newsModule.stubInterface)
        context.newsModule.simulateLoginRequested()
        
        XCTAssertEqual(context.messages.stubInterface, newsNavigationController?.pushedViewControllers.last)
    }
    
    func testWhenTheNewsModuleRequestsShowingPrivateMessagesTheMessagesControllerIsPushedOntoItsNavigationController() {
        context.navigateToTabController()
        let newsNavigationController = context.navigationController(for: context.newsModule.stubInterface)
        context.newsModule.simulatePrivateMessagesDisplayRequested()
        
        XCTAssertEqual(context.messages.stubInterface, newsNavigationController?.pushedViewControllers.last)
    }
    
    func testWhenTheMessagesModuleRequestsDismissalItIsDismissedFromTheTabController() {
        context.navigateToTabController()
        context.newsModule.simulatePrivateMessagesDisplayRequested()
        context.messages.simulateDismissalRequested()
        
        XCTAssertTrue(context.tabModule.stubInterface.didDismissViewController)
    }
    
    func testWhenTheMessagesModuleRequestsDismissalTheNewsNavigationControllersPopsToTheNewsModule() {
        context.navigateToTabController()
        let newsNavigationController = context.navigationController(for: context.newsModule.stubInterface)
        context.newsModule.simulatePrivateMessagesDisplayRequested()
        context.messages.simulateDismissalRequested()
        
        XCTAssertEqual(context.newsModule.stubInterface, newsNavigationController?.viewControllerPoppedTo)
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
