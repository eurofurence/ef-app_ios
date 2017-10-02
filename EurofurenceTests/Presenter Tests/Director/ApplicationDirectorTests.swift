//
//  ApplicationDirectorTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

struct ApplicationDirector: RootModuleDelegate {
    
    private let windowWireframe: WindowWireframe
    private let rootModuleFactory: RootModuleFactory
    private let tutorialModuleFactory: TutorialModuleFactory
    private let preloadModuleFactory: PreloadModuleFactory

    init(windowWireframe: WindowWireframe,
         rootModuleFactory: RootModuleFactory,
         tutorialModuleFactory: TutorialModuleFactory,
         preloadModuleFactory: PreloadModuleFactory) {
        self.windowWireframe = windowWireframe
        self.rootModuleFactory = rootModuleFactory
        self.tutorialModuleFactory = tutorialModuleFactory
        self.preloadModuleFactory = preloadModuleFactory
        
        rootModuleFactory.makeRootModule(self)
    }
    
    func userNeedsToWitnessTutorial() {
        windowWireframe.setRoot(tutorialModuleFactory.makeTutorialModule())
    }
    
    func storeShouldBePreloaded() {
        windowWireframe.setRoot(preloadModuleFactory.makePreloadModule())
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
    
    private(set) var stubInterface: UIViewController = UIViewController()
    func makeTutorialModule() -> UIViewController {
        return stubInterface
    }
    
}

class StubPreloadModuleFactory: PreloadModuleFactory {
    
    private(set) var stubInterface: UIViewController = UIViewController()
    func makePreloadModule() -> UIViewController {
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
    var windowWireframe: CapturingWindowWireframe!
    
    override func setUp() {
        super.setUp()
        
        rootModuleFactory = StubRootModuleFactory()
        tutorialModuleFactory = StubTutorialModuleFactory()
        preloadModuleFactory = StubPreloadModuleFactory()
        windowWireframe = CapturingWindowWireframe()
        director = ApplicationDirector(windowWireframe: windowWireframe,
                                       rootModuleFactory: rootModuleFactory,
                                       tutorialModuleFactory: tutorialModuleFactory,
                                       preloadModuleFactory: preloadModuleFactory)
    }
    
    func testWhenRootModuleIndicatesUserNeedsToWitnessTutorialTheTutorialModuleIsSetAsRoot() {
        rootModuleFactory.delegate?.userNeedsToWitnessTutorial()
        XCTAssertEqual(tutorialModuleFactory.stubInterface, windowWireframe.capturedRootInterface)
    }
    
    func testWhenRootModuleIndicatesStoreShouldPreloadThePreloadModuleIsSetAsRoot() {
        rootModuleFactory.delegate?.storeShouldBePreloaded()
        XCTAssertEqual(preloadModuleFactory.stubInterface, windowWireframe.capturedRootInterface)
    }
    
    
    
}
