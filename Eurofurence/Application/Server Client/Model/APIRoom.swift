//
//  APIRoom.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public struct APIRoom: Equatable {

    public var roomIdentifier: String
    public var name: String

    public init(roomIdentifier: String, name: String) {
        self.roomIdentifier = roomIdentifier
        self.name = name
    }

}
