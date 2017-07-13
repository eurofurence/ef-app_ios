//
//  TutorialPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class TutorialPresenter {

    // MARK: Properties

    private var tutorialScene: TutorialScene
    private var presentationStrings: PresentationStrings
    private var presentationAssets: PresentationAssets
    private var splashScreenRouter: SplashScreenRouter
    private var alertRouter: AlertRouter
    private var tutorialStateProviding: UserCompletedTutorialStateProviding
    private var networkReachability: NetworkReachability
    private var pushPermissionsRequesting: PushPermissionsRequesting
    private var witnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest
    private var witnessedSystemPushPermissionsRequest: WitnessedSystemPushPermissionsRequest

    // MARK: Initialization

    init(tutorialScene: TutorialScene,
         presentationStrings: PresentationStrings,
         presentationAssets: PresentationAssets,
         splashScreenRouter: SplashScreenRouter,
         alertRouter: AlertRouter,
         tutorialStateProviding: UserCompletedTutorialStateProviding,
         witnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest,
         networkReachability: NetworkReachability,
         pushPermissionsRequesting: PushPermissionsRequesting,
         witnessedSystemPushPermissionsRequest: WitnessedSystemPushPermissionsRequest) {
        self.tutorialScene = tutorialScene
        self.presentationStrings = presentationStrings
        self.presentationAssets = presentationAssets
        self.splashScreenRouter = splashScreenRouter
        self.alertRouter = alertRouter
        self.tutorialStateProviding = tutorialStateProviding
        self.networkReachability = networkReachability
        self.pushPermissionsRequesting = pushPermissionsRequesting
        self.witnessedTutorialPushPermissionsRequest = witnessedTutorialPushPermissionsRequest
        self.witnessedSystemPushPermissionsRequest = witnessedSystemPushPermissionsRequest

        if witnessedTutorialPushPermissionsRequest.witnessedTutorialPushPermissionsRequest {
            showInitiateDownloadPage()
        } else {
            showRequestPushPermissionsPage()
        }
    }

    // MARK: Private

    private func showInitiateDownloadPage() {
        _ = InitiateDownloadTutorialPagePresenter(tutorialScene: tutorialScene,
                                                  splashScreenRouter: splashScreenRouter,
                                                  alertRouter: alertRouter,
                                                  presentationAssets: presentationAssets,
                                                  presentationStrings: presentationStrings,
                                                  networkReachability: networkReachability,
                                                  tutorialStateProviding: tutorialStateProviding)
    }

    private func showRequestPushPermissionsPage() {
        let delegate = ShowInitiateDownloadTutorialPage(tutorialScene: tutorialScene,
                                                        splashScreenRouter: splashScreenRouter,
                                                        alertRouter: alertRouter,
                                                        presentationAssets: presentationAssets,
                                                        presentationStrings: presentationStrings,
                                                        networkReachability: networkReachability,
                                                        tutorialStateProviding: tutorialStateProviding)
        _ = RequestPushPermissionsTutorialPagePresenter(delegate: delegate,
                                                        tutorialScene: tutorialScene,
                                                        presentationStrings: presentationStrings,
                                                        presentationAssets: presentationAssets,
                                                        witnessedSystemPushPermissionsRequest: witnessedSystemPushPermissionsRequest,
                                                        witnessedTutorialPushPermissionsRequest: witnessedTutorialPushPermissionsRequest,
                                                        pushPermissionsRequesting: pushPermissionsRequesting)
    }

}
