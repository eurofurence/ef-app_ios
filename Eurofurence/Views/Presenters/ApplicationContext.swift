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
    var acknowledgedPushPermissions: AcknowledgedPushPermissionsRequest
    var quoteGenerator: QuoteGenerator
    var presentationStrings: PresentationStrings
    var presentationAssets: PresentationAssets
    var networkReachability: NetworkReachability
    var pushPermissionsRequesting: PushPermissionsRequesting
    var optedIntoPush: UserOptedIntoPushNotifications

    init(firstTimeLaunchProviding: UserCompletedTutorialStateProviding,
         acknowledgedPushPermissions: AcknowledgedPushPermissionsRequest,
         quoteGenerator: QuoteGenerator,
         presentationStrings: PresentationStrings,
         presentationAssets: PresentationAssets,
         networkReachability: NetworkReachability,
         pushPermissionsRequesting: PushPermissionsRequesting,
         optedIntoPush: UserOptedIntoPushNotifications) {
        self.firstTimeLaunchProviding = firstTimeLaunchProviding
        self.acknowledgedPushPermissions = acknowledgedPushPermissions
        self.quoteGenerator = quoteGenerator
        self.presentationStrings = presentationStrings
        self.presentationAssets = presentationAssets
        self.networkReachability = networkReachability
        self.pushPermissionsRequesting = pushPermissionsRequesting
        self.optedIntoPush = optedIntoPush
    }

}
