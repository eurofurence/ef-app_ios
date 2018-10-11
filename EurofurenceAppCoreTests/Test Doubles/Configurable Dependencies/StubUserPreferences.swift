//
//  StubUserPreferences.swift
//  EurofurenceAppCoreTests
//
//  Created by Thomas Sherwood on 10/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

class StubUserPreferences: UserPreferences {

    var refreshStoreOnLaunch = false
    var upcomingEventReminderInterval: TimeInterval = 0

}
