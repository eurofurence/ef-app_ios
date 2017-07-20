//
//  V2LoginResponse.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct V2LoginResponse: APILoginResponse {

    private static let dateFormatter = Iso8601DateFormatter()

    var uid: String
    var username: String
    var token: String
    var tokenValidUntil: Date

    init?(json: [String : Any]) {
        guard let username = json["Username"] as? String,
            let uid = json["Uid"] as? String,
            let authToken = json["Token"] as? String,
            let dateString = json["TokenValidUntil"] as? String,
            let expiry = V2LoginResponse.dateFormatter.date(from: dateString) else {
                return nil
        }

        self.uid = uid
        self.username = username
        self.token = authToken
        self.tokenValidUntil = expiry
    }

}
