//
//  URLSessionBasedJSONSession.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 16/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct URLSessionBasedJSONSession: JSONSession {

    var session: URLSession = .shared

    func get(_ request: JSONRequest, completionHandler: @escaping (Data?, Error?) -> Void) {
        perform(request, method: "GET", completionHandler: completionHandler)
    }

    func post(_ request: JSONRequest, completionHandler: @escaping (Data?, Error?) -> Void) {
        perform(request, method: "POST", completionHandler: completionHandler)
    }

    private func perform(_ request: JSONRequest, method: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        guard let actualURL = URL(string: request.url) else { return }

        var urlRequest = URLRequest(url: actualURL)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method
        urlRequest.httpBody = request.body
        urlRequest.allHTTPHeaderFields = request.headers

        session.dataTask(with: urlRequest, completionHandler: { (data, _, error) in
            DispatchQueue.main.async {
                completionHandler(data, error)
            }
        }).resume()
    }

}
