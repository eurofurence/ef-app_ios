//
//  StubCollectThemAllRequestFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

class StubCollectThemAllRequestFactory: CollectThemAllRequestFactory {
    
    let anonymousGameURLRequest = URLRequest(url: .random)
    func makeAnonymousGameURLRequest() -> URLRequest {
        return anonymousGameURLRequest
    }
    
    func makeAuthenticatedGameURLRequest(credential: Credential) -> URLRequest {
        let url = URL(string: "https://stub.\(credential.authenticationToken)")!
        return URLRequest(url: url)
    }
    
}
