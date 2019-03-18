//
//  RoomCharacteristics.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public struct RoomCharacteristics: Equatable, Identifyable {

    public var identifier: String
    
    public var name: String

    public init(identifier: String, name: String) {
        self.identifier = identifier
        self.name = name
    }

}
