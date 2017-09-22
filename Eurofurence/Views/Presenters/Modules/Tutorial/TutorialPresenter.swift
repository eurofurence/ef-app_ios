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

    private var context: TutorialPresentationContext

    // MARK: Initialization

    init(context: TutorialPresentationContext) {
        self.context = context

        if context.witnessedTutorialPushPermissionsRequest.witnessedTutorialPushPermissionsRequest {
            showInitiateDownloadPage()
        } else {
            showRequestPushPermissionsPage()
        }
    }

    // MARK: Private

    private func showInitiateDownloadPage() {
        let completeTutorial = CompleteTutorial(splashScreenRouter: context.splashScreenRouter,
                                                tutorialStateProviding: context.tutorialStateProviding)
        _ = InitiateDownloadTutorialPagePresenter(delegate: completeTutorial,
                                                  tutorialScene: context.tutorialScene,
                                                  alertRouter: context.alertRouter,
                                                  presentationAssets: context.presentationAssets,
                                                  presentationStrings: context.presentationStrings,
                                                  networkReachability: context.networkReachability)
    }

    private func showRequestPushPermissionsPage() {
        let delegate = ShowInitiateDownloadTutorialPage(tutorialScene: context.tutorialScene,
                                                        splashScreenRouter: context.splashScreenRouter,
                                                        alertRouter: context.alertRouter,
                                                        presentationAssets: context.presentationAssets,
                                                        presentationStrings: context.presentationStrings,
                                                        networkReachability: context.networkReachability,
                                                        tutorialStateProviding: context.tutorialStateProviding)
        _ = RequestPushPermissionsTutorialPagePresenter(delegate: delegate,
                                                        tutorialScene: context.tutorialScene,
                                                        presentationStrings: context.presentationStrings,
                                                        presentationAssets: context.presentationAssets,
                                                        pushPermissionsStateProviding: context.pushPermissionsStateProviding,
                                                        witnessedTutorialPushPermissionsRequest: context.witnessedTutorialPushPermissionsRequest,
                                                        pushPermissionsRequesting: context.pushPermissionsRequesting)
    }

}
