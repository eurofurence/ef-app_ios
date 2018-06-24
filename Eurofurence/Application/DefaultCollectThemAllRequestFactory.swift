//
//  DefaultCollectThemAllRequestFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct DefaultCollectThemAllRequestFactory: CollectThemAllRequestFactory {

    private let baseURL = URL(string: "https://app.eurofurence.org/collectemall/")!

    func makeAnonymousGameURLRequest() -> URLRequest {
        return URLRequest(url: baseURL)
    }

    func makeAuthenticatedGameURLRequest(credential: Credential) -> URLRequest {
        let authenticatedURL = baseURL.appendingPathComponent("#token-\(credential.authenticationToken)")
        return URLRequest(url: authenticatedURL)
    }

}
