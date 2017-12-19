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
        app.resolveDataStoreState { (state) in
            switch state {
            case .absent:
                delegate.userNeedsToWitnessTutorial()

            case .stale:
                delegate.storeShouldBePreloaded()

            case .available:
                delegate.rootModuleDidDetermineRootModuleShouldBePresented()
            }
        }
    }

}
