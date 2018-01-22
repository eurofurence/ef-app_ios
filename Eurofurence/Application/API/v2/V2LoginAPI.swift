//
//  V2LoginAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct V2LoginAPI: LoginAPI {

    // MARK: Properties

    private let jsonSession: JSONSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    // MARK: Initialization

    init(jsonSession: JSONSession) {
        self.jsonSession = jsonSession

        // TODO: Investigate why system ios8601 formatter fails to parse our dates
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Iso8601DateFormatter())

        encoder = JSONEncoder()
    }

    // MARK: LoginAPI

    func performLogin(request: LoginRequest, completionHandler: @escaping (LoginResponse?) -> Void) {
        let url = "https://app.eurofurence.org/api/v2/Tokens/RegSys"
        let jsonData = try! encoder.encode(Request(from: request))
        let jsonRequest = JSONRequest(url: url, body: jsonData)
        jsonSession.post(jsonRequest) { (data, _) in
            if let data = data, let response = try? self.decoder.decode(JSONResponse.self, from: data) {
                completionHandler(response.makeDomainLoginResponse())
            } else {
                completionHandler(nil)
            }
        }
    }

    // MARK: Private

    private struct Request: Encodable {
        var RegNo: Int
        var Username: String
        var Password: String

        init(from request: LoginRequest) {
            RegNo = request.regNo
            Username = request.username
            Password = request.password
        }
    }

    private struct JSONResponse: Decodable {

        var uid: String
        var username: String
        var token: String
        var tokenValidUntil: Date

        private enum CodingKeys: String, CodingKey {
            case uid = "Uid"
            case username = "Username"
            case token = "Token"
            case tokenValidUntil = "TokenValidUntil"
        }

        func makeDomainLoginResponse() -> LoginResponse {
            return LoginResponse(userIdentifier: uid,
                                 username: username,
                                 token: token,
                                 tokenValidUntil: tokenValidUntil)
        }

    }

}
