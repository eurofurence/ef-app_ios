//
//  LoginArguments.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

public struct LoginArguments: Equatable {

    public var registrationNumber: Int
    public var username: String
    public var password: String

    public init(registrationNumber: Int, username: String, password: String) {
        self.registrationNumber = registrationNumber
        self.username = username
        self.password = password
    }

}
