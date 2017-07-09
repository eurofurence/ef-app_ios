//
//  StubRouters.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

struct StubRouters: Routers {

    init(tutorialRouter: TutorialRouter = CapturingTutorialRouter(),
         splashScreenRouter: SplashScreenRouter = CapturingSplashScreenRouter()) {
        self.tutorialRouter = tutorialRouter
        self.splashScreenRouter = splashScreenRouter
    }

    var tutorialRouter: TutorialRouter
    var splashScreenRouter: SplashScreenRouter
    
}
