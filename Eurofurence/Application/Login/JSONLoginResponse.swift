//
//  JSONLoginResponse.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct JSONLoginResponse {

    private static let dateFormatter = Iso8601DateFormatter()

    var userID: Int
    var username: String
    var authToken: String
    var authTokenExpiry: Date

    init?(json: [String : Any]) {
        var userID: Int = 0
        guard let username = json["Username"] as? String,
            let userIDString = json["Uid"] as? String,
            let authToken = json["Token"] as? String,
            let dateString = json["TokenValidUntil"] as? String,
            let expiry = JSONLoginResponse.dateFormatter.date(from: dateString),
            Scanner(string: userIDString).scanInt(&userID) else {
                return nil
        }

        self.userID = userID
        self.username = username
        self.authToken = authToken
        self.authTokenExpiry = expiry
    }

}
