//
//  StubRouters.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore

struct StubRouters: Routers {

    init(tutorialRouter: TutorialRouter = CapturingTutorialRouter(),
         splashScreenRouter: SplashScreenRouter = CapturingSplashScreenRouter(),
         alertRouter: AlertRouter = CapturingAlertRouter()) {
        self.tutorialRouter = tutorialRouter
        self.splashScreenRouter = splashScreenRouter
        self.alertRouter = alertRouter
    }

    var tutorialRouter: TutorialRouter
    var splashScreenRouter: SplashScreenRouter
    var alertRouter: AlertRouter
    
}
