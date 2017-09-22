//
//  TutorialModule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct TutorialModule {

    static func initialize(context: ApplicationContext, routers: Routers) {
        let tutorialContext = TutorialPresentationContext(
            tutorialScene: routers.tutorialRouter.showTutorial(),
            presentationStrings: context.presentationStrings,
            presentationAssets: context.presentationAssets,
            splashScreenRouter: routers.splashScreenRouter,
            alertRouter: routers.alertRouter,
            tutorialStateProviding: context.firstTimeLaunchProviding,
            networkReachability: context.networkReachability,
            pushPermissionsRequesting: context.pushPermissionsRequesting,
            witnessedTutorialPushPermissionsRequest: context.witnessedTutorialPushPermissionsRequest)

        _ = TutorialPresenter(context: tutorialContext)
    }

}
