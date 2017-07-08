//
//  CapturingTutorialRouter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingTutorialRouter: TutorialRouter {

    private(set) var wasToldToShowTutorial = false
    func showTutorial() {
        wasToldToShowTutorial = true
    }
    
}
