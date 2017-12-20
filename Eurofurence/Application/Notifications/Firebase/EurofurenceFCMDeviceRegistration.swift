//
//  EurofurenceFCMDeviceRegistration.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct EurofurenceFCMDeviceRegistration: FCMDeviceRegistration {

    var JSONSession: JSONSession
    private let jsonEncoder = JSONEncoder()

    func registerFCM(_ fcm: String,
                     topics: [FirebaseTopic],
                     authenticationToken: String?,
                     completionHandler: @escaping (Error?) -> Void) {
        let registrationRequest = Request(DeviceId: fcm, Topics: topics.map({ $0.description }))
        let jsonData = try! jsonEncoder.encode(registrationRequest)

        let registrationURL = "https://app.eurofurence.org/api/v2/PushNotifications/FcmDeviceRegistration"
        var request = JSONRequest(url: registrationURL, body: jsonData)

        if let token = authenticationToken {
            request.headers = ["Authorization": "Bearer \(token)"]
        }

        JSONSession.post(request, completionHandler: { (_, error) in completionHandler(error) })
    }

    private struct Request: Encodable {
        var DeviceId: String
        var Topics: [String]
    }

}
