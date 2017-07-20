//
//  V2LoginAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class V2LoginAPI {

    private var jsonPoster: JSONPoster

    init(jsonPoster: JSONPoster) {
        self.jsonPoster = jsonPoster
    }

    func performLogin(arguments: LoginArguments,
                      completionHandler: @escaping (APIResponse<LoginCredential>) -> Void) {
        do {
            let postArguments: [String : Any] = ["RegNo": arguments.registrationNumber,
                                                 "Username": arguments.username,
                                                 "Password": arguments.password]
            let jsonData = try JSONSerialization.data(withJSONObject: postArguments, options: [])
            let request = POSTRequest(url: "https://app.eurofurence.org/api/v2/Tokens/RegSys", body: jsonData)
            jsonPoster.post(request) { data in
                guard let responseData = data,
                    let json = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments),
                    let jsonDictionary = json as? [String : Any],
                    let response = JSONLoginResponse(json: jsonDictionary) else {
                        completionHandler(.failure)
                        return
                }

                let credential = LoginCredential(username: response.username,
                                                 registrationNumber: response.userID,
                                                 authenticationToken: response.authToken,
                                                 tokenExpiryDate: response.authTokenExpiry)
                completionHandler(.success(credential))
            }
        } catch {
            print("Unable to perform login due to error: \(error)")
        }
    }

}
