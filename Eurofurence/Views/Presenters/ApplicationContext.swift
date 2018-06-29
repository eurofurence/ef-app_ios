//
//  ApplicationContext.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct ApplicationContext {

    var firstTimeLaunchProviding: UserCompletedTutorialStateProviding
    var witnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest
    var presentationAssets: PresentationAssets
    var networkReachability: NetworkReachability
    var pushPermissionsRequesting: PushPermissionsRequesting

    init(firstTimeLaunchProviding: UserCompletedTutorialStateProviding,
         witnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest,
         presentationAssets: PresentationAssets,
         networkReachability: NetworkReachability,
         pushPermissionsRequesting: PushPermissionsRequesting) {
        self.firstTimeLaunchProviding = firstTimeLaunchProviding
        self.witnessedTutorialPushPermissionsRequest = witnessedTutorialPushPermissionsRequest
        self.presentationAssets = presentationAssets
        self.networkReachability = networkReachability
        self.pushPermissionsRequesting = pushPermissionsRequesting
    }

}
