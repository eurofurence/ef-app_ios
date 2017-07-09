//
//  BootstrappingModule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct BootstrappingModule {

    static func bootstrap(context: ApplicationContext, routers: Routers) {
        if context.firstTimeLaunchProviding.userHasCompletedTutorial {
            routers.splashScreenRouter.showSplashScreen()
        } else {
            TutorialModule.initialize(context: context, routers: routers)
        }
    }

}
