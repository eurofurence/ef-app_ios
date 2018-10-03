//
//  UserPreferences.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol UserPreferences {

    var refreshStoreOnLaunch: Bool { get }
    var upcomingEventReminderInterval: TimeInterval { get }

}
