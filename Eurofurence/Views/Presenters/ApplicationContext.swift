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
    var tutorialItems: [TutorialPageInfo]
    var quoteGenerator: QuoteGenerator

    init(firstTimeLaunchProviding: UserCompletedTutorialStateProviding,
         tutorialItems: [TutorialPageInfo],
         quoteGenerator: QuoteGenerator) {
        self.firstTimeLaunchProviding = firstTimeLaunchProviding
        self.tutorialItems = tutorialItems
        self.quoteGenerator = quoteGenerator
    }

}
