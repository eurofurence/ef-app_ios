//
//  V2PrivateMessagesAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct V2PrivateMessagesAPI: PrivateMessagesAPI {

    var jsonPoster: JSONPoster

    func loadPrivateMessages(authorizationToken: String,
                             completionHandler: @escaping (APIResponse<APIPrivateMessagesResponse>) -> Void) {
        var request = POSTRequest(url: "https://app.eurofurence.org/api/v2/Communication/PrivateMessages", body: Data())
        request.headers = ["Authorization": "Bearer \(authorizationToken)"]
        jsonPoster.post(request) { _ in

        }
    }

}
