//
//  EurofurenceFCMDeviceRegistration.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct EurofurenceFCMDeviceRegistration: FCMDeviceRegistration {

    private var jsonPoster: JSONPoster

    init(jsonPoster: JSONPoster) {
        self.jsonPoster = jsonPoster
    }

    func registerFCM(_ fcm: String, topics: [FirebaseTopic]) {
        let formattedTopics = topics.map({ $0.rawValue })
        let jsonDictionary: [String : Any] = ["DeviceId": fcm, "Topics": formattedTopics]
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDictionary, options: [])

        jsonPoster.post("https://app.eurofurence.org/api/v2/PushNotifications/FcmDeviceRegistration",
                        body: jsonData)
    }

}
