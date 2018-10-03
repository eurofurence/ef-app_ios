//
//  V2ImageAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public struct V2ImageAPI: ImageAPI {

    private let jsonSession: JSONSession
    let apiUrl: String

    public init(jsonSession: JSONSession, apiUrl: V2ApiUrlProviding) {
        self.jsonSession = jsonSession
        self.apiUrl = apiUrl.url
    }

    public func fetchImage(identifier: String, completionHandler: @escaping (Data?) -> Void) {
        let url = apiUrl + "Images/\(identifier)/Content"
        let request = JSONRequest(url: url, body: Data())
        jsonSession.get(request) { (data, _) in
            completionHandler(data)
        }
    }

}
