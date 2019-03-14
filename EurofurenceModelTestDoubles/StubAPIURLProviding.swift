//
//  StubAPIURLProviding.swift
//  EurofurenceTests
//
//  Created by Dominik Schöner on 20/06/18.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel

public struct StubAPIURLProviding: APIURLProviding {

    public init(url: String = "https://api.example.com/v2/") {
        self.url = url
    }

    public let url: String

}
