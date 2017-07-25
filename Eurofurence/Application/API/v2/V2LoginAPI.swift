//
//  V2LoginAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class V2LoginAPI: LoginAPI {

    private var jsonPoster: JSONPoster

    init(jsonPoster: JSONPoster) {
        self.jsonPoster = jsonPoster
    }

    func performLogin(arguments: APILoginParameters,
                      completionHandler: @escaping LoginResponseHandler) {
        do {
            let jsonData = try makeLoginBody(from: arguments)
            performLogin(body: jsonData, completionHandler: completionHandler)
        } catch {
            print("Unable to perform login due to error: \(error)")
        }
    }

    private func makeLoginBody(from arguments: APILoginParameters) throws -> Data {
        let postArguments: [String : Any] = ["RegNo": arguments.regNo,
                                             "Username": arguments.username,
                                             "Password": arguments.password]
        return try JSONSerialization.data(withJSONObject: postArguments, options: [])
    }

    private func performLogin(body: Data, completionHandler: @escaping LoginResponseHandler) {
        let request = Request(url: "https://app.eurofurence.org/api/v2/Tokens/RegSys", body: body)
        jsonPoster.post(request) { data in
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
