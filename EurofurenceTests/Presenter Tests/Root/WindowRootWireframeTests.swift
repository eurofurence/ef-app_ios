//
//  WindowRootWireframeTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 27/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import XCTest
import UIKit

struct WindowRootWireframe: RootWireframe {
    
    private let window: UIWindow
    private let tutorialModuleComposer: TutorialModuleComposer
    private let preloadModuleComposer: PreloadModuleComposer
    
    init(window: UIWindow,
         tutorialModuleComposer: TutorialModuleComposer,
         preloadModuleComposer: PreloadModuleComposer) {
        self.window = window
        self.tutorialModuleComposer = tutorialModuleComposer
        self.preloadModuleComposer = preloadModuleComposer
    }
    
    func showTutorialScreen() {
        window.rootViewController = tutorialModuleComposer.makeTutorialModule()
    }
    
    func showPreloadScreen() {
        window.rootViewController = preloadModuleComposer.makePreloadModule()
    }
    
}

protocol TutorialModuleComposer {
    
    func makeTutorialModule() -> UIViewController
    
}

struct StubTutorialModuleComposer: TutorialModuleComposer {
    
    var stubbedTutorialScene = UIViewController()
    func makeTutorialModule() -> UIViewController {
        return stubbedTutorialScene
    }
    
}

protocol PreloadModuleComposer {
    
    func makePreloadModule() -> UIViewController
    
}

struct StubPreloadModuleComposer: PreloadModuleComposer {
    
    let stubbedPreloadModule = UIViewController()
    func makePreloadModule() -> UIViewController {
        return stubbedPreloadModule
    }
    
}

class WindowRootWireframeTests: XCTestCase {
    
    func testShowingTutorialScreenSetsTheTutorialSceneAsTheRootControllerOntoTheWindow() {
        let tutorialModuleComposer = StubTutorialModuleComposer()
        let window = UIWindow()
        let wireframe = WindowRootWireframe(window: window,
                                            tutorialModuleComposer: tutorialModuleComposer,
                                            preloadModuleComposer: StubPreloadModuleComposer())
        wireframe.showTutorialScreen()
        
        XCTAssertTrue(tutorialModuleComposer.stubbedTutorialScene === window.rootViewController)
    }
    
    func testShowingPreloadScreenSetsThePreloadSceneAsTheRootControllerOntoTheWindow() {
        let preloadModuleComposer = StubPreloadModuleComposer()
        let window = UIWindow()
        let wireframe = WindowRootWireframe(window: window,
                                            tutorialModuleComposer: StubTutorialModuleComposer(),
                                            preloadModuleComposer: preloadModuleComposer)
        wireframe.showPreloadScreen()
        
        XCTAssertTrue(preloadModuleComposer.stubbedPreloadModule === window.rootViewController)
    }
    
}
