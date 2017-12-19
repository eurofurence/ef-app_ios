//
//  V2LoginAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class V2LoginAPI: LoginAPI {

    private var JSONSession: JSONSession

    private struct Request: Encodable {
        var RegNo: Int
        var Username: String
        var Password: String
    }

    init(JSONSession: JSONSession) {
        self.JSONSession = JSONSession
    }

    func performLogin(request: LoginRequest) {
        do {
            let jsonData = try makeLoginBody(from: request)
            performLogin(body: jsonData, completionHandler: request.completionHandler)
        } catch {
            print("Unable to perform login due to error: \(error)")
        }
    }

    private func makeLoginBody(from request: LoginRequest) throws -> Data {
        let jsonRequest = Request(RegNo: request.regNo, Username: request.username, Password: request.password)
        return try JSONEncoder().encode(jsonRequest)
    }

    private func performLogin(body: Data, completionHandler: @escaping LoginResponseHandler) {
        let request = JSONRequest(url: "https://app.eurofurence.org/api/v2/Tokens/RegSys", body: body)
        JSONSession.post(request) { (data, _) in
            if let data = data, let response = try? V2LoginResponse.decoder.decode(V2LoginResponse.self, from: data) {
                completionHandler(.success(response))
            } else {
                completionHandler(.failure)
            }
        }
    }

}
