//
//  DefaultCollectThemAllRequestFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct DefaultCollectThemAllRequestFactory: CollectThemAllRequestFactory {

    func makeAnonymousGameURLRequest() -> URLRequest {
        return URLRequest(url: makeGameURL(token: "empty"))
    }

    func makeAuthenticatedGameURLRequest(credential: Credential) -> URLRequest {
        return URLRequest(url: makeGameURL(token: credential.authenticationToken))
    }

    private func makeGameURL(token: String) -> URL {
        let urlString = "https://app.eurofurence.org/collectemall/#token-\(token)/true"
        return URL(string: urlString)!
    }

}
