//
//  LoginArguments.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct LoginArguments: Equatable {

    var registrationNumber: Int
    var username: String
    var password: String

    static func ==(lhs: LoginArguments, rhs: LoginArguments) -> Bool {
        return lhs.registrationNumber == rhs.registrationNumber &&
               lhs.username == rhs.username &&
               lhs.password == rhs.password
    }

}
