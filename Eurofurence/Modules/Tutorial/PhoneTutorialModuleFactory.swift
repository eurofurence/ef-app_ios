//
//  PhoneTutorialModuleFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import UIKit

struct PhoneTutorialModuleFactory: TutorialModuleProviding {

    var tutorialSceneFactory: TutorialSceneFactory
    var presentationAssets: PresentationAssets
    var alertRouter: AlertRouter
    var tutorialStateProviding: UserCompletedTutorialStateProviding
    var networkReachability: NetworkReachability
    var pushPermissionsRequesting: PushPermissionsRequesting
    var witnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest

    func makeTutorialModule(_ delegate: TutorialModuleDelegate) -> UIViewController {
        struct DummySplashScreenRouter: SplashScreenRouter {
            func showSplashScreen() -> SplashScene {
                class DummySplashScene: SplashScene {
                    var delegate: SplashSceneDelegate?

                    func showQuote(_ quote: String) {

                    }

                    func showQuoteAuthor(_ author: String) {

                    }

                    func showProgress(_ progress: Float, progressDescription: String) {

                    }
                }

                return DummySplashScene()
            }
        }

        let tutorialScene = tutorialSceneFactory.makeTutorialScene()
        let tutorialContext = TutorialPresentationContext(
            tutorialScene: tutorialScene,
            presentationAssets: presentationAssets,
            splashScreenRouter: DummySplashScreenRouter(),
            alertRouter: alertRouter,
            tutorialStateProviding: tutorialStateProviding,
            networkReachability: networkReachability,
            pushPermissionsRequesting: pushPermissionsRequesting,
            witnessedTutorialPushPermissionsRequest: witnessedTutorialPushPermissionsRequest)

        _ = TutorialPresenter(delegate: delegate, context: tutorialContext)

        return tutorialScene
    }

}
