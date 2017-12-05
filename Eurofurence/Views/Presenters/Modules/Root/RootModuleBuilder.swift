//
//  RootModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 05/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

class RootModuleBuilder {

    private var firstTimeLaunchStateProviding: UserCompletedTutorialStateProviding

    init() {
        firstTimeLaunchStateProviding = UserDefaultsTutorialStateProvider(userDefaults: .standard)
    }

    func with(_ firstTimeLaunchStateProviding: UserCompletedTutorialStateProviding) -> RootModuleBuilder {
        self.firstTimeLaunchStateProviding = firstTimeLaunchStateProviding
        return self
    }

    func build() -> RootModuleProviding {
        return PhoneRootModuleFactory(firstTimeLaunchStateProviding: firstTimeLaunchStateProviding)
    }

}
