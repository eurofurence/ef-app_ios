//
//  NotificationsService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol NotificationsService {

    func register(deviceToken: Data)

    func subscribeToTestNotifications()
    func unsubscribeFromTestNotifications()

    func subscribeToLiveNotifications()
    func unsubscribeFromLiveNotifications()

}
