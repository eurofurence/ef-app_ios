//
//  StubV2ApiUrlProviding.swift
//  EurofurenceTests
//
//  Created by Dominik Schöner on 20/06/18.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore

public struct StubV2ApiUrlProviding : V2ApiUrlProviding {
    
    public init() {
        
    }
    
    public let url = "https://api.example.com/v2/"
    
}
