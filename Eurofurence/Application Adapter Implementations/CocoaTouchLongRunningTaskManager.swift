//
//  CocoaTouchLongRunningTaskManager.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

struct CocoaTouchLongRunningTaskManager: LongRunningTaskManager {

    private let app = UIApplication.shared

    func beginLongRunningTask() -> AnyHashable {
        var identifier: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
        identifier = app.beginBackgroundTask(expirationHandler: {
            self.finishLongRunningTask(token: identifier)
        })

        return identifier
    }

    func finishLongRunningTask(token: AnyHashable) {
        guard let task = token as? UIBackgroundTaskIdentifier else { return }
        app.endBackgroundTask(task)
    }

}
