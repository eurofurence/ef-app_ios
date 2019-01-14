//
//  TrackCharacteristics.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 21/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public struct TrackCharacteristics: Equatable {

    public var trackIdentifier: String
    public var name: String

    public init(trackIdentifier: String, name: String) {
        self.trackIdentifier = trackIdentifier
        self.name = name
    }

}
