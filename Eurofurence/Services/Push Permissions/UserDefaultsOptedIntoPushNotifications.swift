//
//  UserDefaultsOptedIntoPushNotifications.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct UserDefaultsOptedIntoPushNotifications: UserOptedIntoPushNotifications {

    static let OptedIntoPushKey = "Eurofurence.UserOptedIntoPush"

    var userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    var userOptedIntoPush: Bool {
        return userDefaults.bool(forKey: UserDefaultsOptedIntoPushNotifications.OptedIntoPushKey)
    }

    func markUserOptedIntoPushNotifications() {
        userDefaults.set(true, forKey: UserDefaultsOptedIntoPushNotifications.OptedIntoPushKey)
    }

}
