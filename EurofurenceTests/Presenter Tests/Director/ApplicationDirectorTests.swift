//
//  ApplicationDirectorTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingNavigationController: UINavigationController {
    
    private(set) var pushedViewControllers = [UIViewController]()
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewControllers.append(viewController)
        super.pushViewController(viewController, animated: animated)
    }
    
    private(set) var viewControllerPoppedTo: UIViewController?
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        viewControllerPoppedTo = viewController
        return super.popToViewController(viewController, animated: animated)
    }
    
}

struct StubNavigationControllerFactory: NavigationControllerFactory {
    
    func makeNavigationController() -> UINavigationController {
        return CapturingNavigationController()
    }
    
}

class StubRootModuleFactory: RootModuleProviding {
    
    private(set) var delegate: RootModuleDelegate?
    func makeRootModule(_ delegate: RootModuleDelegate) {
        self.delegate = delegate
    }
    
}

class StubTutorialModuleFactory: TutorialModuleProviding {
    
    let stubInterface = UIViewController()
    private(set) var delegate: TutorialModuleDelegate?
    func makeTutorialModule(_ delegate: TutorialModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }
    
}

class StubPreloadModuleFactory: PreloadModuleProviding {
    
    let stubInterface = UIViewController()
    private(set) var delegate: PreloadModuleDelegate?
    func makePreloadModule(_ delegate: PreloadModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }
    
}

class StubNewsModuleFactory: NewsModuleProviding {
    
    let stubInterface = UIViewController()
    private(set) var delegate: NewsModuleDelegate?
    func makeNewsModule(_ delegate: NewsModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }
    
}

class StubMessagesModuleFactory: MessagesModuleProviding {
    
    let stubInterface = UIViewController()
    private(set) var delegate: MessagesModuleDelegate?
    func makeMessagesModule(_ delegate: MessagesModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }
    
}

class FakeViewController: UIViewController {
    
    private(set) var capturedPresentedViewController: UIViewController?
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        capturedPresentedViewController = viewControllerToPresent
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    private(set) var didDismissViewController = false
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        didDismissViewController = true
        super.dismiss(animated: flag, completion: completion)
    }
    
}

class StubTabModuleFactory: TabModuleProviding {
    
    let stubInterface = FakeViewController()
    private(set) var capturedTabModules: [UIViewController] = []
    func makeTabModule(_ childModules: [UIViewController]) -> UIViewController {
        capturedTabModules = childModules
        return stubInterface
    }
    
    func navigationController(for viewController: UIViewController) -> CapturingNavigationController? {
        return capturedTabModules
                .flatMap({ $0 as? CapturingNavigationController })
                .first(where: { $0.topViewController === viewController })
    }
    
}

class StubLoginModuleFactory: LoginModuleProviding {
    
    let stubInterface = UIViewController()
    private(set) var delegate: LoginModuleDelegate?
    func makeLoginModule(_ delegate: LoginModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }
    
}

class CapturingWindowWireframe: WindowWireframe {
    
    private(set) var capturedRootInterface: UIViewController?
    func setRoot(_ viewController: UIViewController) {
        capturedRootInterface = viewController
    }
    
}

class StubMessageDetailModuleProviding: MessageDetailModuleProviding {
    
    let stubInterface = UIViewController()
    private(set) var capturedMessage: Message?
    func makeMessageDetailModule(message: Message) -> UIViewController {
        capturedMessage = message
        return stubInterface
    }
    
}

class StubKnowledgeListModuleProviding: KnowledgeListModuleProviding {
    
    let stubInterface = UIViewController()
    private(set) var delegate: KnowledgeListModuleDelegate?
    func makeKnowledgeListModule(_ delegate: KnowledgeListModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }
    
}

class StubKnowledgeDetailModuleProviding: KnowledgeDetailModuleProviding {
    
    let stubInterface = UIViewController()
    private(set) var capturedModel: KnowledgeEntry2?
    private(set) var delegate: KnowledgeDetailModuleDelegate?
    func makeKnowledgeListModule(_ knowledgeEntry: KnowledgeEntry2, delegate: KnowledgeDetailModuleDelegate) -> UIViewController {
        capturedModel = knowledgeEntry
        self.delegate = delegate
        return stubInterface
    }
    
}

class StubLinkRouter: LinkLookupService {
    
    var stubbedLinkActions = [Link : LinkRouterAction]()
    func resolveAction(for link: Link) -> LinkRouterAction? {
        return stubbedLinkActions[link]
    }
    
}

class StubWebMobuleProviding: WebMobuleProviding {
    
    var producedWebModules = [URL : UIViewController]()
    func makeWebModule(for url: URL) -> UIViewController {
        let module = UIViewController()
        producedWebModules[url] = module
        
        return module
    }
    
}

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
    
    private func navigateToTabController() {
        rootModuleFactory.delegate?.rootModuleDidDetermineStoreShouldRefresh()
        preloadModuleFactory.delegate?.preloadModuleDidFinishPreloading()
    }
    
    private var rootNavigationController: UINavigationController {
        return windowWireframe.capturedRootInterface as! UINavigationController
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
        let expected: [UIViewController] = [newsModuleFactory.stubInterface, knowledgeListModuleProviding.stubInterface]
        let actual = tabModuleFactory.capturedTabModules.flatMap({ $0 as? UINavigationController }).flatMap({ $0.topViewController })
        
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
        _ = tabModuleFactory.navigationController(for: newsModuleFactory.stubInterface)
        newsModuleFactory.delegate?.newsModuleDidRequestShowingPrivateMessages()
        messagesModuleFactory.delegate?.messagesModuleDidRequestResolutionForUser(completionHandler: { _ in })
        let navController = tabModuleFactory.stubInterface.capturedPresentedViewController as? UINavigationController
        
        XCTAssertEqual(navController?.topViewController, loginModuleFactory.stubInterface)
    }
    
    func testWhenTheMessagesModuleRequestsResolutionForUserTheLoginModuleIsPresentedUsingTheFormSheetModalPresentationStyle() {
        navigateToTabController()
        _ = tabModuleFactory.navigationController(for: newsModuleFactory.stubInterface)
        newsModuleFactory.delegate?.newsModuleDidRequestShowingPrivateMessages()
        messagesModuleFactory.delegate?.messagesModuleDidRequestResolutionForUser(completionHandler: { _ in })
        
        XCTAssertEqual(loginModuleFactory.stubInterface.modalPresentationStyle, .formSheet)
    }
    
    func testWhenShowingLoginForMessagesControllerWhenModuleCancelsLoginTheMessagesModuleIsToldResolutionFailed() {
        navigateToTabController()
        _ = tabModuleFactory.navigationController(for: newsModuleFactory.stubInterface)
        newsModuleFactory.delegate?.newsModuleDidRequestShowingPrivateMessages()
        var userResolved = true
        messagesModuleFactory.delegate?.messagesModuleDidRequestResolutionForUser(completionHandler: { userResolved = $0 })
        loginModuleFactory.delegate?.loginModuleDidCancelLogin()
        
        XCTAssertFalse(userResolved)
    }
    
    func testWhenShowingLoginForMessagesControllerTheMessagesModuleIsNotToldResolutionFailedBeforeLoginIsCancelled() {
        navigateToTabController()
        _ = tabModuleFactory.navigationController(for: newsModuleFactory.stubInterface)
        newsModuleFactory.delegate?.newsModuleDidRequestShowingPrivateMessages()
        var userResolved = true
        messagesModuleFactory.delegate?.messagesModuleDidRequestResolutionForUser(completionHandler: { userResolved = $0 })
        
        XCTAssertTrue(userResolved)
    }
    
    func testWhenShowingLoginForMessagesControllerWhenModuleLogsInTheMessagesModuleIsToldResolutionSucceeded() {
        navigateToTabController()
        _ = tabModuleFactory.navigationController(for: newsModuleFactory.stubInterface)
        newsModuleFactory.delegate?.newsModuleDidRequestShowingPrivateMessages()
        var userResolved = false
        messagesModuleFactory.delegate?.messagesModuleDidRequestResolutionForUser(completionHandler: { userResolved = $0 })
        loginModuleFactory.delegate?.loginModuleDidLoginSuccessfully()
        
        XCTAssertTrue(userResolved)
    }
    
    func testWhenShowingLoginForMessagesControllerTheMessagesModuleIsNotToldResolutionSucceededBeforeUserLogsIn() {
        navigateToTabController()
        _ = tabModuleFactory.navigationController(for: newsModuleFactory.stubInterface)
        newsModuleFactory.delegate?.newsModuleDidRequestShowingPrivateMessages()
        var userResolved = false
        messagesModuleFactory.delegate?.messagesModuleDidRequestResolutionForUser(completionHandler: { userResolved = $0 })
        
        XCTAssertFalse(userResolved)
    }
    
    func testWhenShowingLoginForMessagesControllerWhenLoginSucceedsItIsDismissed() {
        navigateToTabController()
        _ = tabModuleFactory.navigationController(for: newsModuleFactory.stubInterface)
        newsModuleFactory.delegate?.newsModuleDidRequestShowingPrivateMessages()
        messagesModuleFactory.delegate?.messagesModuleDidRequestResolutionForUser { (_) in }
        loginModuleFactory.delegate?.loginModuleDidLoginSuccessfully()
        
        XCTAssertTrue(tabModuleFactory.stubInterface.didDismissViewController)
    }
    
    func testWhenMessagesModuleRequestsPresentationForMessageTheMessageDetailModuleIsBuiltUsingChosenMessage() {
        navigateToTabController()
        _ = tabModuleFactory.navigationController(for: newsModuleFactory.stubInterface)
        newsModuleFactory.delegate?.newsModuleDidRequestShowingPrivateMessages()
        let message = AppDataBuilder.makeMessage()
        messagesModuleFactory.delegate?.messagesModuleDidRequestPresentation(for: message)
        
        XCTAssertEqual(message, messageDetailModuleFactory.capturedMessage)
    }
    
    func testWhenMessagesModuleRequestsPresentationForMessageTheMessageDetailModuleInterfaceIsPushedOntoMessagesNavigationController() {
        navigateToTabController()
        _ = tabModuleFactory.navigationController(for: newsModuleFactory.stubInterface)
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
    
}
