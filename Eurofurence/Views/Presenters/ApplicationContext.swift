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
    var quoteGenerator: QuoteGenerator
    var presentationStrings: PresentationStrings
    var presentationAssets: PresentationAssets
    var networkReachability: NetworkReachability

    init(firstTimeLaunchProviding: UserCompletedTutorialStateProviding,
         quoteGenerator: QuoteGenerator,
         presentationStrings: PresentationStrings,
         presentationAssets: PresentationAssets,
         networkReachability: NetworkReachability) {
        self.firstTimeLaunchProviding = firstTimeLaunchProviding
        self.quoteGenerator = quoteGenerator
        self.presentationStrings = presentationStrings
        self.presentationAssets = presentationAssets
        self.networkReachability = networkReachability
    }

}
