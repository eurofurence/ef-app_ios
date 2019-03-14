//
//  CIDAPIURLProviding.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 14/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

public struct CIDAPIURLProviding: APIURLProviding {
    
    public init(conventionIdentifier: ConventionIdentifier) {
        url = "https://app.eurofurence.org/\(conventionIdentifier.identifier)/api"
    }
    
    public var url: String
    
}
