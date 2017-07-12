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
    var userAcknowledgedPushPermissionsRequest: UserAcknowledgedPushPermissionsRequestStateProviding
    var quoteGenerator: QuoteGenerator
    var presentationStrings: PresentationStrings
    var presentationAssets: PresentationAssets
    var networkReachability: NetworkReachability
    var pushPermissionsRequesting: PushPermissionsRequesting

    init(firstTimeLaunchProviding: UserCompletedTutorialStateProviding,
         userAcknowledgedPushPermissionsRequest: UserAcknowledgedPushPermissionsRequestStateProviding,
         quoteGenerator: QuoteGenerator,
         presentationStrings: PresentationStrings,
         presentationAssets: PresentationAssets,
         networkReachability: NetworkReachability,
         pushPermissionsRequesting: PushPermissionsRequesting) {
        self.firstTimeLaunchProviding = firstTimeLaunchProviding
        self.userAcknowledgedPushPermissionsRequest = userAcknowledgedPushPermissionsRequest
        self.quoteGenerator = quoteGenerator
        self.presentationStrings = presentationStrings
        self.presentationAssets = presentationAssets
        self.networkReachability = networkReachability
        self.pushPermissionsRequesting = pushPermissionsRequesting
    }

}
