//
//  V2ImageAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct V2ImageAPI: ImageAPI {

    private let jsonSession: JSONSession

    init(jsonSession: JSONSession) {
        self.jsonSession = jsonSession
    }

    func fetchImage(identifier: String, completionHandler: @escaping (Data?) -> Void) {
        let request = JSONRequest(url: "https://app.eurofurence.org/api/v2/Images/\(identifier)/Content", body: Data())
        jsonSession.get(request) { (data, _) in
            completionHandler(data)
        }
    }

}
