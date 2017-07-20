//
//  URLSessionJSONPoster.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 16/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct URLSessionJSONPoster: JSONPoster {

    var session: URLSession = .shared

    func post(_ request: POSTRequest, completionHandler: @escaping (Data?) -> Void) {
        guard let actualURL = URL(string: request.url) else { return }

        var urlRequest = URLRequest(url: actualURL)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = request.body
        urlRequest.allHTTPHeaderFields = request.headers

        session.dataTask(with: urlRequest, completionHandler: { (data, _, _) in
            DispatchQueue.main.async {
                completionHandler(data)
            }
        }).resume()
    }

}
