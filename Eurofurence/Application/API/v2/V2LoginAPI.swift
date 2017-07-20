//
//  V2LoginAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

typealias LoginResponseHandler = (APIResponse<LoginCredential>) -> Void

class V2LoginAPI {

    private var jsonPoster: JSONPoster

    init(jsonPoster: JSONPoster) {
        self.jsonPoster = jsonPoster
    }

    func performLogin(arguments: APILoginParameters,
                      completionHandler: @escaping (APIResponse<LoginCredential>) -> Void) {
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

    private func performLogin(body: Data, completionHandler: @escaping (APIResponse<LoginCredential>) -> Void) {
        let request = POSTRequest(url: "https://app.eurofurence.org/api/v2/Tokens/RegSys", body: body)
        jsonPoster.post(request) { data in
            guard let responseData = data,
                let json = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments),
                let jsonDictionary = json as? [String : Any],
                let response = JSONLoginResponse(json: jsonDictionary) else {
                    completionHandler(.failure)
                    return
            }

            let credential = LoginCredential(username: response.username,
                                             registrationNumber: response.uid,
                                             authenticationToken: response.token,
                                             tokenExpiryDate: response.tokenValidUntil)
            completionHandler(.success(credential))
        }
    }

}
