//
//  CapturingTutorialScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingTutorialScene: TutorialScene {

    let tutorialPage = CapturingTutorialPageScene()

    private(set) var wasToldToShowTutorialPage = false
    func showTutorialPage() -> TutorialPageScene {
        wasToldToShowTutorialPage = true
        return tutorialPage
    }

}
