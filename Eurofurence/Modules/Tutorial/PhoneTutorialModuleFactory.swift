//
//  TutorialModule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation
import UIKit

protocol TutorialModuleDelegate {

    func tutorialModuleDidFinishPresentingTutorial()

}

struct TutorialModule: TutorialModuleProviding {

    var tutorialSceneFactory: TutorialSceneFactory
    var presentationAssets: PresentationAssets
    var alertRouter: AlertRouter
    var tutorialStateProviding: UserCompletedTutorialStateProviding
    var networkReachability: NetworkReachability
    var pushPermissionsRequesting: PushPermissionsRequester
    var witnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest

    func makeTutorialModule(_ delegate: TutorialModuleDelegate) -> UIViewController {
        let tutorialScene = tutorialSceneFactory.makeTutorialScene()
        let tutorialContext = TutorialPresentationContext(
            tutorialScene: tutorialScene,
            presentationAssets: presentationAssets,
            alertRouter: alertRouter,
            tutorialStateProviding: tutorialStateProviding,
            networkReachability: networkReachability,
            witnessedTutorialPushPermissionsRequest: witnessedTutorialPushPermissionsRequest)

        _ = TutorialPresenter(delegate: delegate, context: tutorialContext)

        return tutorialScene
    }

}
