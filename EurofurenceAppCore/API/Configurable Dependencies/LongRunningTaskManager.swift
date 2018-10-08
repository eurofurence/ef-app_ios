//
//  LongRunningTaskManager.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public protocol LongRunningTaskManager {

    func beginLongRunningTask() -> AnyHashable
    func finishLongRunningTask(token: AnyHashable)

}
