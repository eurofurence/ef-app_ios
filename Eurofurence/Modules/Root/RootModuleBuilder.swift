//
//  RootModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 05/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel

class RootModuleBuilder {

    private var sessionStateService: SessionStateService

    init() {
        sessionStateService = SharedModel.instance.services.sessionState
    }

    @discardableResult
    func with(_ dataStoreStateService: SessionStateService) -> RootModuleBuilder {
        self.sessionStateService = dataStoreStateService
        return self
    }

    func build() -> RootModuleProviding {
        return RootModule(sessionStateService: sessionStateService)
    }

}
