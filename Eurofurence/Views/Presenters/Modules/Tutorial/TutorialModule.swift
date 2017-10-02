//
//  TutorialModule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol TutorialModuleDelegate {

    func tutorialModuleDidFinishPresentingTutorial()

}

struct TutorialModule: PresentationModule {

    static func initialize(context: ApplicationContext, routers: Routers) {
        struct DummyTutorialModuleDelegate: TutorialModuleDelegate {

            func tutorialModuleDidFinishPresentingTutorial() {

            }

        }

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

        _ = TutorialPresenter(delegate: DummyTutorialModuleDelegate(), context: tutorialContext)
    }

    private let delegate: TutorialModuleDelegate
    private let tutorialSceneFactory: TutorialSceneFactory
    private let presentationStrings: PresentationStrings
    private let presentationAssets: PresentationAssets
    private let alertRouter: AlertRouter
    private let tutorialStateProviding: UserCompletedTutorialStateProviding
    private let networkReachability: NetworkReachability
    private let pushPermissionsRequesting: PushPermissionsRequesting
    private let witnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest

    init(delegate: TutorialModuleDelegate,
         tutorialSceneFactory: TutorialSceneFactory,
         presentationStrings: PresentationStrings,
         presentationAssets: PresentationAssets,
         alertRouter: AlertRouter,
         tutorialStateProviding: UserCompletedTutorialStateProviding,
         networkReachability: NetworkReachability,
         pushPermissionsRequesting: PushPermissionsRequesting,
         witnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest) {
        self.delegate = delegate
        self.tutorialSceneFactory = tutorialSceneFactory
        self.presentationStrings = presentationStrings
        self.presentationAssets = presentationAssets
        self.alertRouter = alertRouter
        self.tutorialStateProviding = tutorialStateProviding
        self.networkReachability = networkReachability
        self.pushPermissionsRequesting = pushPermissionsRequesting
        self.witnessedTutorialPushPermissionsRequest = witnessedTutorialPushPermissionsRequest
    }

    func attach(to wireframe: PresentationWireframe) {
        struct DummySplashScreenRouter: SplashScreenRouter {
            func showSplashScreen() -> SplashScene {
                class DummySplashScene: SplashScene {
                    var delegate: SplashSceneDelegate?

                    func showQuote(_ quote: String) {

                    }

                    func showQuoteAuthor(_ author: String) {

                    }

                    func showProgress(_ progress: Float) {

                    }
                }

                return DummySplashScene()
            }
        }

        let tutorialScene = tutorialSceneFactory.makeTutorialScene()
        let tutorialContext = TutorialPresentationContext(
            tutorialScene: tutorialScene,
            presentationStrings: presentationStrings,
            presentationAssets: presentationAssets,
            splashScreenRouter: DummySplashScreenRouter(),
            alertRouter: alertRouter,
            tutorialStateProviding: tutorialStateProviding,
            networkReachability: networkReachability,
            pushPermissionsRequesting: pushPermissionsRequesting,
            witnessedTutorialPushPermissionsRequest: witnessedTutorialPushPermissionsRequest)

        _ = TutorialPresenter(delegate: delegate, context: tutorialContext)

        wireframe.show(tutorialScene)
    }

}
