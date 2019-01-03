//
//  PhoneRootModuleFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel

struct PhoneRootModuleFactory: RootModuleProviding {

    var dataStoreStateService: DataStoreStateService

    func makeRootModule(_ delegate: RootModuleDelegate) {
        let actions: [EurofurenceDataStoreState : () -> Void] = [
            .absent: delegate.rootModuleDidDetermineTutorialShouldBePresented,
            .stale: delegate.rootModuleDidDetermineStoreShouldRefresh,
            .available: delegate.rootModuleDidDetermineRootModuleShouldBePresented
        ]

        dataStoreStateService.resolveDataStoreState { actions[$0]!() }
    }

}
