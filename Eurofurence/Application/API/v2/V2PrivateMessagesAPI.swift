//
//  V2PrivateMessagesAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct V2PrivateMessagesAPI: PrivateMessagesAPI {

    struct JSONAPIPrivateMessagesResponse: APIPrivateMessagesResponse {

        var messages: [APIPrivateMessage] = []

    }

    var jsonPoster: JSONPoster

    func loadPrivateMessages(authorizationToken: String,
                             completionHandler: @escaping (APIResponse<APIPrivateMessagesResponse>) -> Void) {
        var request = POSTRequest(url: "https://app.eurofurence.org/api/v2/Communication/PrivateMessages", body: Data())
        request.headers = ["Authorization": "Bearer \(authorizationToken)"]
        jsonPoster.post(request) { data in
            guard let data = data else {
                completionHandler(.failure)
                return
            }

            guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
                completionHandler(.failure)
                return
            }

            guard let response = jsonObject as? [[String : Any]] else {
                completionHandler(.failure)
                return
            }

            let messages = response.flatMap(V2APIPrivateMessage.init)
            completionHandler(.success(JSONAPIPrivateMessagesResponse(messages: messages)))
        }
    }

}

struct V2APIPrivateMessage: APIPrivateMessage {

    var id: String = ""
    var authorName: String = ""
    var subject: String = ""
    var message: String = ""
    var recipientUid: String = ""

    init?(jsonDictionary: [String : Any]) {
        guard let id = jsonDictionary["Id"] as? String,
              let authorName = jsonDictionary["AuthorName"] as? String,
              let subject = jsonDictionary["Subject"] as? String,
              let message = jsonDictionary["Message"] as? String,
              let recipientUid = jsonDictionary["RecipientUid"] as? String else {
            return nil
        }

        self.id = id
        self.authorName = authorName
        self.subject = subject
        self.message = message
        self.recipientUid = recipientUid
    }

}
