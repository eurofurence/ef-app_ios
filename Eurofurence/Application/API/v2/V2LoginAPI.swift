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
        let postArguments: [String : Any] = ["RegNo": request.regNo,
                                             "Username": request.username,
                                             "Password": request.password]
        return try JSONSerialization.data(withJSONObject: postArguments, options: [])
    }

    private func performLogin(body: Data, completionHandler: @escaping LoginResponseHandler) {
        let request = Request(url: "https://app.eurofurence.org/api/v2/Tokens/RegSys", body: body)
        JSONSession.post(request) { data, _ in
            guard let responseData = data,
                let json = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments),
                let jsonDictionary = json as? [String : Any],
                let response = V2LoginResponse(json: jsonDictionary) else {
                    completionHandler(.failure)
                    return
            }

            completionHandler(.success(response))
        }
    }

}
