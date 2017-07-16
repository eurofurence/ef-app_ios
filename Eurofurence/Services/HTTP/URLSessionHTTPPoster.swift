//
//  URLSessionHTTPPoster.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 16/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct URLSessionHTTPPoster: HTTPPoster {

    var session: URLSession = .shared

    func post(_ url: String, body: Data) {
        guard let actualURL = URL(string: url) else { return }

        var request = URLRequest(url: actualURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = body

        session.dataTask(with: request, completionHandler: { (_, _, _) in }).resume()
    }

}
