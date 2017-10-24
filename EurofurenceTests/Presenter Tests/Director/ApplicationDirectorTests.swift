//
//  ApplicationDirectorTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

struct ApplicationDirector: RootModuleDelegate,
                            TutorialModuleDelegate,
                            PreloadModuleDelegate {
    
    private let windowWireframe: WindowWireframe
    private let rootModuleFactory: RootModuleFactory
    private let tutorialModuleFactory: TutorialModuleFactory
    private let preloadModuleFactory: PreloadModuleFactory
    private let tabModuleFactory: TabModuleFactory
    private let newsModuleFactory: NewsModuleFactory

    init(windowWireframe: WindowWireframe,
         rootModuleFactory: RootModuleFactory,
         tutorialModuleFactory: TutorialModuleFactory,
         preloadModuleFactory: PreloadModuleFactory,
         tabModuleFactory: TabModuleFactory,
         newsModuleFactory: NewsModuleFactory) {
        self.windowWireframe = windowWireframe
        self.rootModuleFactory = rootModuleFactory
        self.tutorialModuleFactory = tutorialModuleFactory
        self.preloadModuleFactory = preloadModuleFactory
        self.tabModuleFactory = tabModuleFactory
        self.newsModuleFactory = newsModuleFactory
        
        rootModuleFactory.makeRootModule(self)
    }
    
    // MARK: RootModuleDelegate
    
    func userNeedsToWitnessTutorial() {
        showTutorial()
    }
    
    func storeShouldBePreloaded() {
        showPreloadModule()
    }
    
    // MARK: TutorialModuleDelegate
    
    func tutorialModuleDidFinishPresentingTutorial() {
        showPreloadModule()
    }
    
    // MARK: PreloadModuleDelegate
    
    func preloadModuleDidCancelPreloading() {
        showTutorial()
    }
    
    func preloadModuleDidFinishPreloading() {
        let childModuleControllers = [newsModuleFactory.makeNewsModule()]
        let wrappedControllers = childModuleControllers.map(UINavigationController.init(rootViewController:))
        let tabModule = tabModuleFactory.makeTabModule(wrappedControllers)
        
        windowWireframe.setRoot(tabModule)
    }
    
    // MARK: Private
    
    private func showPreloadModule() {
        windowWireframe.setRoot(preloadModuleFactory.makePreloadModule(self))
    }
    
    private func showTutorial() {
        windowWireframe.setRoot(tutorialModuleFactory.makeTutorialModule(self))
    }
    
}

protocol WindowWireframe {
    
    func setRoot(_ viewController: UIViewController)
    
}

class StubRootModuleFactory: RootModuleFactory {
    
    private(set) var delegate: RootModuleDelegate?
    func makeRootModule(_ delegate: RootModuleDelegate) {
        self.delegate = delegate
    }
    
}

class StubTutorialModuleFactory: TutorialModuleFactory {
    
    let stubInterface = UIViewController()
    private(set) var delegate: TutorialModuleDelegate?
    func makeTutorialModule(_ delegate: TutorialModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }
    
}

class StubPreloadModuleFactory: PreloadModuleFactory {
    
    let stubInterface = UIViewController()
    private(set) var delegate: PreloadModuleDelegate?
    func makePreloadModule(_ delegate: PreloadModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }
    
}

class StubNewsModuleFactory: NewsModuleFactory {
    
    let stubInterface = UIViewController()
    func makeNewsModule() -> UIViewController {
        return stubInterface
    }
    
}

class StubTabModuleFactory: TabModuleFactory {
    
    let stubInterface = UIViewController()
    private(set) var capturedTabModules: [UIViewController] = []
    func makeTabModule(_ childModules: [UIViewController]) -> UIViewController {
        capturedTabModules = childModules
        return stubInterface
    }
    
}

class CapturingWindowWireframe: WindowWireframe {
    
    private(set) var capturedRootInterface: UIViewController?
    func setRoot(_ viewController: UIViewController) {
        capturedRootInterface = viewController
    }
    
}

class ApplicationDirectorTests: XCTestCase {
    
    var director: ApplicationDirector!
    var rootModuleFactory: StubRootModuleFactory!
    var tutorialModuleFactory: StubTutorialModuleFactory!
    var preloadModuleFactory: StubPreloadModuleFactory!
    var tabModuleFactory: StubTabModuleFactory!
    var newsModuleFactory: StubNewsModuleFactory!
    var windowWireframe: CapturingWindowWireframe!
    
    override func setUp() {
        super.setUp()
        
        rootModuleFactory = StubRootModuleFactory()
        tutorialModuleFactory = StubTutorialModuleFactory()
        preloadModuleFactory = StubPreloadModuleFactory()
        windowWireframe = CapturingWindowWireframe()
        tabModuleFactory = StubTabModuleFactory()
        newsModuleFactory = StubNewsModuleFactory()
        director = ApplicationDirector(windowWireframe: windowWireframe,
                                       rootModuleFactory: rootModuleFactory,
                                       tutorialModuleFactory: tutorialModuleFactory,
                                       preloadModuleFactory: preloadModuleFactory,
                                       tabModuleFactory: tabModuleFactory,
                                       newsModuleFactory: newsModuleFactory)
    }
    
    func testWhenRootModuleIndicatesUserNeedsToWitnessTutorialTheTutorialModuleIsSetAsRoot() {
        rootModuleFactory.delegate?.userNeedsToWitnessTutorial()
        XCTAssertEqual(tutorialModuleFactory.stubInterface, windowWireframe.capturedRootInterface)
    }
    
    func testWhenRootModuleIndicatesStoreShouldPreloadThePreloadModuleIsSetAsRoot() {
        rootModuleFactory.delegate?.storeShouldBePreloaded()
        XCTAssertEqual(preloadModuleFactory.stubInterface, windowWireframe.capturedRootInterface)
    }
    
    func testWhenTheTutorialFinishesThePreloadModuleIsSetAsRoot() {
        rootModuleFactory.delegate?.userNeedsToWitnessTutorial()
        tutorialModuleFactory.delegate?.tutorialModuleDidFinishPresentingTutorial()
        
        XCTAssertEqual(preloadModuleFactory.stubInterface, windowWireframe.capturedRootInterface)
    }
    
    func testWhenPreloadingFailsAfterFinishingTutorialTheTutorialIsRedisplayed() {
        rootModuleFactory.delegate?.userNeedsToWitnessTutorial()
        tutorialModuleFactory.delegate?.tutorialModuleDidFinishPresentingTutorial()
        preloadModuleFactory.delegate?.preloadModuleDidCancelPreloading()
        
        XCTAssertEqual(tutorialModuleFactory.stubInterface, windowWireframe.capturedRootInterface)
    }
    
    func testWhenPreloadingSucceedsAfterFinishingTutorialTheTabWireframeIsSetAsTheRoot() {
        rootModuleFactory.delegate?.userNeedsToWitnessTutorial()
        tutorialModuleFactory.delegate?.tutorialModuleDidFinishPresentingTutorial()
        preloadModuleFactory.delegate?.preloadModuleDidFinishPreloading()
        
        XCTAssertEqual(tabModuleFactory.stubInterface, windowWireframe.capturedRootInterface)
    }
    
    func testWhenShowingTheTheTabModuleItIsInitialisedWithControllersForTabModulesNestedInNavigationControllers() {
        rootModuleFactory.delegate?.storeShouldBePreloaded()
        preloadModuleFactory.delegate?.preloadModuleDidFinishPreloading()
        
        let expected: [UIViewController] = [newsModuleFactory.stubInterface]
        let actual = tabModuleFactory.capturedTabModules.flatMap({ $0 as? UINavigationController }).flatMap({ $0.topViewController })
        
        XCTAssertEqual(expected, actual)
    }
    
}
