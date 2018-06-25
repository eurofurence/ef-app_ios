//
//  DefaultCollectThemAllRequestFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct DefaultCollectThemAllRequestFactory: CollectThemAllRequestFactory {

    private let baseURLString = "https://app.eurofurence.org/collectemall/"

    func makeAnonymousGameURLRequest() -> URLRequest {
        return URLRequest(url: URL(string: baseURLString)!)
    }

    func makeAuthenticatedGameURLRequest(credential: Credential) -> URLRequest {
        let authenticatedURL = "\(baseURLString)#token-\(credential.authenticationToken)"
        return URLRequest(url: URL(string: authenticatedURL)!)
    }

}
