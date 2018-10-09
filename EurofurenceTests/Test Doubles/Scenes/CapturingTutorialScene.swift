//
//  CapturingTutorialScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import UIKit

struct StubTutorialSceneFactory: TutorialSceneFactory {
    
    let tutorialScene = CapturingTutorialScene()
    func makeTutorialScene() -> UIViewController & TutorialScene {
        return tutorialScene
    }
    
}

class CapturingTutorialScene: UIViewController, TutorialScene {

    let tutorialPage = CapturingTutorialPageScene()

    private(set) var wasToldToShowTutorialPage = false
    private(set) var numberOfPagesShown = 0
    func showTutorialPage() -> TutorialPageScene {
        wasToldToShowTutorialPage = true
        numberOfPagesShown += 1
        return tutorialPage
    }

}
