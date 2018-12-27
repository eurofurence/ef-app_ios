//
//  ApplicationLongRunningTaskManager.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import UIKit

struct ApplicationLongRunningTaskManager: LongRunningTaskManager {

    private let app = UIApplication.shared

    func beginLongRunningTask() -> AnyHashable {
        var identifier: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
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
