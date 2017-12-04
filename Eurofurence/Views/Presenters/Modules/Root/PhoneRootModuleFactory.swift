//
//  PhoneRootModuleFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct PhoneRootModuleFactory: RootModuleProviding {

    var firstTimeLaunchStateProviding: UserCompletedTutorialStateProviding

    func makeRootModule(_ delegate: RootModuleDelegate) {
        if firstTimeLaunchStateProviding.userHasCompletedTutorial {
            delegate.storeShouldBePreloaded()
        } else {
            delegate.userNeedsToWitnessTutorial()
        }
    }

}
