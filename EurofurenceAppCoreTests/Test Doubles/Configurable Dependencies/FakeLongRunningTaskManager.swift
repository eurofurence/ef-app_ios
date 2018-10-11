//
//  FakeLongRunningTaskManager.swift
//  EurofurenceAppCoreTests
//
//  Created by Thomas Sherwood on 10/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

class FakeLongRunningTaskManager: LongRunningTaskManager {

    var finishedTask: Bool {
        return terminatedLongRunningTaskToken == AnyHashable(stubTaskToken)
    }

    let stubTaskToken = String.random
    private(set) var didBeginTask = false
    func beginLongRunningTask() -> AnyHashable {
        didBeginTask = true
        return stubTaskToken
    }

    private(set) var terminatedLongRunningTaskToken: AnyHashable?
    func finishLongRunningTask(token: AnyHashable) {
        terminatedLongRunningTaskToken = token
    }

}
