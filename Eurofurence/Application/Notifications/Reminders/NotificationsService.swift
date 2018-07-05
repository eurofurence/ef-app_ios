//
//  NotificationsService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 05/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol NotificationsService {

    func scheduleReminderForEvent(identifier: Event2.Identifier, scheduledFor date: Date, title: String)

}
