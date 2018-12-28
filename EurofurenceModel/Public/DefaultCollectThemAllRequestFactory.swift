//
//  DefaultCollectThemAllRequestFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public struct DefaultCollectThemAllRequestFactory: CollectThemAllRequestFactory {

    public init() {
    }

    public func makeAnonymousGameURLRequest() -> URLRequest {
        return URLRequest(url: makeGameURL(token: "empty"))
    }

    public func makeAuthenticatedGameURLRequest(credential: Credential) -> URLRequest {
        return URLRequest(url: makeGameURL(token: credential.authenticationToken))
    }

    private func makeGameURL(token: String) -> URL {
        let urlString = "https://app.eurofurence.org/collectemall/#token-\(token)/true"
        return URL(string: urlString)!
    }

}
