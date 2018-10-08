//
//  TutorialPresentationContext.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

struct TutorialPresentationContext {

    var tutorialScene: TutorialScene
    var presentationAssets: PresentationAssets
    var splashScreenRouter: SplashScreenRouter
    var alertRouter: AlertRouter
    var tutorialStateProviding: UserCompletedTutorialStateProviding
    var networkReachability: NetworkReachability
    var pushPermissionsRequesting: PushPermissionsRequester
    var witnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest

}
