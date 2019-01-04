//
//  PhoneRootModuleFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel

struct PhoneRootModuleFactory: RootModuleProviding {

    var sessionStateService: SessionStateService

    func makeRootModule(_ delegate: RootModuleDelegate) {
        let actions: [EurofurenceSessionState : () -> Void] = [
            .uninitialized: delegate.rootModuleDidDetermineTutorialShouldBePresented,
            .stale: delegate.rootModuleDidDetermineStoreShouldRefresh,
            .initialized: delegate.rootModuleDidDetermineRootModuleShouldBePresented
        ]

        sessionStateService.determineSessionState { actions[$0]!() }
    }

}
