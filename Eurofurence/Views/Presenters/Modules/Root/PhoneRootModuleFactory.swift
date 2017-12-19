//
//  PhoneRootModuleFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

struct PhoneRootModuleFactory: RootModuleProviding {

    var app: EurofurenceApplicationProtocol

    func makeRootModule(_ delegate: RootModuleDelegate) {
        let actions: [EurofurenceDataStoreState : () -> Void] = [
            .absent: delegate.userNeedsToWitnessTutorial,
            .stale: delegate.storeShouldBePreloaded,
            .available: delegate.rootModuleDidDetermineRootModuleShouldBePresented
        ]

        app.resolveDataStoreState { actions[$0]!() }
    }

}
