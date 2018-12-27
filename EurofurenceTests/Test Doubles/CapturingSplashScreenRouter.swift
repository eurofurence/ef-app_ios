//
//  CapturingSplashScreenRouter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import Foundation

class CapturingSplashScreenRouter: SplashScreenRouter {

    let splashScene = CapturingSplashScene()

    private(set) var wasToldToShowSplashScreen = false
    func showSplashScreen() -> SplashScene {
        wasToldToShowSplashScreen = true
        return splashScene
    }

}
