//
//  Map.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public typealias MapIdentifier = Identifier<Map>

public protocol Map {

    var identifier: MapIdentifier { get }
    var location: String { get }

}

struct MapImpl: Map {

    var identifier: MapIdentifier
    var location: String

    init(identifier: MapIdentifier, location: String) {
        self.identifier = identifier
        self.location = location
    }

}
