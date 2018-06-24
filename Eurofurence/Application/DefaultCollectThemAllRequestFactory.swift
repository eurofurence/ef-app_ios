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
        return URLRequest(url: URL(string: "https://app.eurofurence.org/collectemall/")!)
    }

}
