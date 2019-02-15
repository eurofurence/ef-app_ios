//
//  MapImpl.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 15/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

struct MapImpl: Map {

    var identifier: MapIdentifier
    var location: String

    init(identifier: MapIdentifier, location: String) {
        self.identifier = identifier
        self.location = location
    }

}
