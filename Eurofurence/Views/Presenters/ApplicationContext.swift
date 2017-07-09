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

    init(firstTimeLaunchProviding: UserCompletedTutorialStateProviding,
         tutorialItems: [TutorialPageInfo]) {
        self.firstTimeLaunchProviding = firstTimeLaunchProviding
        self.tutorialItems = tutorialItems
    }

}
