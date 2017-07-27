//
//  V2PrivateMessagesAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct V2PrivateMessagesAPI: PrivateMessagesAPI {

    var JSONSession: JSONSession

    func loadPrivateMessages(authorizationToken: String,
                             completionHandler: @escaping (APIResponse<APIPrivateMessagesResponse>) -> Void) {
        var request = Request(url: "https://app.eurofurence.org/api/v2/Communication/PrivateMessages", body: Data())
        request.headers = ["Authorization": "Bearer \(authorizationToken)"]
        JSONSession.get(request) { data in
            guard let data = data,
                  let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                  let response = jsonObject as? [[String : Any]],
                  let apiResponse = V2APIPrivateMessagesResponse(json: response) else {
                completionHandler(.failure)
                return
            }

            completionHandler(.success(apiResponse))
        }
    }

    func markMessageWithIdentifierAsRead(_ identifier: String, authorizationToken: String) {
        let request = Request(url: "https://app.eurofurence.org/api/v2/Communication/PrivateMessages/\(identifier)/Read",
                              body: Data())
        JSONSession.post(request, completionHandler: { _ in })
    }

}
