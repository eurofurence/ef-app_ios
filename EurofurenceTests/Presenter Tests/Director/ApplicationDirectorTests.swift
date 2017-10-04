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

    init(windowWireframe: WindowWireframe,
         rootModuleFactory: RootModuleFactory,
         tutorialModuleFactory: TutorialModuleFactory,
         preloadModuleFactory: PreloadModuleFactory,
         tabModuleFactory: TabModuleFactory) {
        self.windowWireframe = windowWireframe
        self.rootModuleFactory = rootModuleFactory
        self.tutorialModuleFactory = tutorialModuleFactory
        self.preloadModuleFactory = preloadModuleFactory
        self.tabModuleFactory = tabModuleFactory
        
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
        windowWireframe.setRoot(tabModuleFactory.makeTabModule())
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

class StubTabModuleFactory: TabModuleFactory {
    
    let stubInterface = UIViewController()
    func makeTabModule() -> UIViewController {
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
    var windowWireframe: CapturingWindowWireframe!
    
    override func setUp() {
        super.setUp()
        
        rootModuleFactory = StubRootModuleFactory()
        tutorialModuleFactory = StubTutorialModuleFactory()
        preloadModuleFactory = StubPreloadModuleFactory()
        windowWireframe = CapturingWindowWireframe()
        tabModuleFactory = StubTabModuleFactory()
        director = ApplicationDirector(windowWireframe: windowWireframe,
                                       rootModuleFactory: rootModuleFactory,
                                       tutorialModuleFactory: tutorialModuleFactory,
                                       preloadModuleFactory: preloadModuleFactory,
                                       tabModuleFactory: tabModuleFactory)
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
    
}
