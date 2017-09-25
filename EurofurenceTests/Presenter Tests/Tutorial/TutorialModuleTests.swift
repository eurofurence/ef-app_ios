//
//  TutorialModuleTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 25/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

struct StubTutorialSceneFactory: TutorialSceneFactory {
    
    let tutorialScene = CapturingTutorialScene()
    func makeTutorialScene() -> TutorialScene {
        return tutorialScene
    }
    
}

class TutorialModuleTests: XCTestCase {
    
    func testSetTheTutorialSceneAsTheRootOntoTheWireframe() {
        let tutorialSceneFactory = StubTutorialSceneFactory()
        let wireframe = CapturingPresentationWireframe()
        let module = TutorialModule(tutorialSceneFactory: tutorialSceneFactory)
        module.attach(to: wireframe)
        
        XCTAssertTrue(tutorialSceneFactory.tutorialScene === wireframe.capturedRootScene)
    }
    
}
