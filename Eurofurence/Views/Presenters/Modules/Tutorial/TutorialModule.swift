//
//  TutorialModule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct TutorialModule: PresentationModule {

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

    private let tutorialSceneFactory: TutorialSceneFactory
    private let presentationStrings: PresentationStrings
    private let presentationAssets: PresentationAssets
    private let splashScreenRouter: SplashScreenRouter
    private let alertRouter: AlertRouter
    private let tutorialStateProviding: UserCompletedTutorialStateProviding
    private let networkReachability: NetworkReachability
    private let pushPermissionsRequesting: PushPermissionsRequesting
    private let witnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest

    init(tutorialSceneFactory: TutorialSceneFactory,
         presentationStrings: PresentationStrings,
         presentationAssets: PresentationAssets,
         splashScreenRouter: SplashScreenRouter,
         alertRouter: AlertRouter,
         tutorialStateProviding: UserCompletedTutorialStateProviding,
         networkReachability: NetworkReachability,
         pushPermissionsRequesting: PushPermissionsRequesting,
         witnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest) {
        self.tutorialSceneFactory = tutorialSceneFactory
        self.presentationStrings = presentationStrings
        self.presentationAssets = presentationAssets
        self.splashScreenRouter = splashScreenRouter
        self.alertRouter = alertRouter
        self.tutorialStateProviding = tutorialStateProviding
        self.networkReachability = networkReachability
        self.pushPermissionsRequesting = pushPermissionsRequesting
        self.witnessedTutorialPushPermissionsRequest = witnessedTutorialPushPermissionsRequest
    }

    func attach(to wireframe: PresentationWireframe) {
        let tutorialScene = tutorialSceneFactory.makeTutorialScene()
        let tutorialContext = TutorialPresentationContext(
            tutorialScene: tutorialScene,
            presentationStrings: presentationStrings,
            presentationAssets: presentationAssets,
            splashScreenRouter: splashScreenRouter,
            alertRouter: alertRouter,
            tutorialStateProviding: tutorialStateProviding,
            networkReachability: networkReachability,
            pushPermissionsRequesting: pushPermissionsRequesting,
            witnessedTutorialPushPermissionsRequest: witnessedTutorialPushPermissionsRequest)

        _ = TutorialPresenter(context: tutorialContext)

        wireframe.show(tutorialScene)
    }

}
