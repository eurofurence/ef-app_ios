//
//  CapturingNotificationsService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingNotificationsService: NotificationsService {

    private(set) var registeredDeviceToken: Data?
    func register(deviceToken: Data) {
        registeredDeviceToken = deviceToken
    }

    private(set) var subscribedToTestNotifications = false
    func subscribeToTestNotifications() {
        subscribedToTestNotifications = true
    }

    private(set) var unsubscribedFromTestNotifications = false
    func unsubscribeFromTestNotifications() {
        unsubscribedFromTestNotifications = true
    }

    private(set) var subscribedToLiveNotifications = false
    func subscribeToLiveNotifications() {
        subscribedToLiveNotifications = true
    }

    private(set) var unsubscribedFromLiveNotifications = false
    func unsubscribeFromLiveNotifications() {
        unsubscribedFromLiveNotifications = true
    }
    
}

