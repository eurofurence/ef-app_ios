//
//  RootModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 05/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel

class RootModuleBuilder {

    private var app: EurofurenceApplicationProtocol

    init() {
        app = EurofurenceApplication.shared
    }

    @discardableResult
    func with(_ app: EurofurenceApplicationProtocol) -> RootModuleBuilder {
        self.app = app
        return self
    }

    func build() -> RootModuleProviding {
        return PhoneRootModuleFactory(app: app)
    }

}
