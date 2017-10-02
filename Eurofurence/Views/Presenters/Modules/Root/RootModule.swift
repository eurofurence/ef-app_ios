//
//  RootModule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 02/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

struct RootModule {

    init(delegate: RootModuleDelegate,
         firstTimeLaunchStateProviding: UserCompletedTutorialStateProviding) {
        if firstTimeLaunchStateProviding.userHasCompletedTutorial {
            delegate.storeShouldBePreloaded()
        } else {
            delegate.userNeedsToWitnessTutorial()
        }
    }

}
