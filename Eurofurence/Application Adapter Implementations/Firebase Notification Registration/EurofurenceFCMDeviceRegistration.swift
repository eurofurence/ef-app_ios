//
//  EurofurenceFCMDeviceRegistration.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

public struct EurofurenceFCMDeviceRegistration: FCMDeviceRegistration {

    var JSONSession: JSONSession
    var urlProviding: APIURLProviding

    public init(JSONSession: JSONSession, urlProviding: APIURLProviding) {
        self.JSONSession = JSONSession
        self.urlProviding = urlProviding
    }

    private let jsonEncoder = JSONEncoder()

    public func registerFCM(_ fcm: String,
                     topics: [FirebaseTopic],
                     authenticationToken: String?,
                     completionHandler: @escaping (Error?) -> Void) {
        let registrationRequest = Request(DeviceId: fcm, Topics: topics.map({ $0.description }))
        let jsonData = try! jsonEncoder.encode(registrationRequest)

        let registrationURL = urlProviding.url + "PushNotifications/FcmDeviceRegistration"
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
