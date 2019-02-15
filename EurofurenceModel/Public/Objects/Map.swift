//
//  Map.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public typealias MapIdentifier = Identifier<Map>

public protocol MapProtocol {

    var identifier: MapIdentifier { get }
    var location: String { get }

}

public struct Map: MapProtocol {

    public var identifier: MapIdentifier
    public var location: String

    public init(identifier: MapIdentifier, location: String) {
        self.identifier = identifier
        self.location = location
    }

}
