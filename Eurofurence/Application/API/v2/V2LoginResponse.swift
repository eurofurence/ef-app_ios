//
//  V2LoginResponse.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct V2LoginResponse: APILoginResponse, Decodable {

    var uid: String
    var username: String
    var token: String
    var tokenValidUntil: Date

    // Decodable Support

    static var decoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()

        // TODO: Investigate why system ios8601 formatter fails to parse our dates
        jsonDecoder.dateDecodingStrategy = .formatted(Iso8601DateFormatter())

        return jsonDecoder
    }()

    private enum CodingKeys: String, CodingKey {
        case uid = "Uid"
        case username = "Username"
        case token = "Token"
        case tokenValidUntil = "TokenValidUntil"
    }

}
