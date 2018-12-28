//
//  User.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

public struct User: Equatable {

    public var registrationNumber: Int
    public var username: String

    public init(registrationNumber: Int, username: String) {
        self.registrationNumber = registrationNumber
        self.username = username
    }

}
