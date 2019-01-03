//
//  RootModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 05/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel

class RootModuleBuilder {

    private var dataStoreStateService: DataStoreStateService

    init() {
        dataStoreStateService = SharedModel.instance.session
    }

    @discardableResult
    func with(_ dataStoreStateService: DataStoreStateService) -> RootModuleBuilder {
        self.dataStoreStateService = dataStoreStateService
        return self
    }

    func build() -> RootModuleProviding {
        return PhoneRootModuleFactory(dataStoreStateService: dataStoreStateService)
    }

}
