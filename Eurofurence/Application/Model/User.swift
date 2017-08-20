//
//  User.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct User: Equatable {

    var registrationNumber: Int
    var username: String

    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.registrationNumber == rhs.registrationNumber &&
               lhs.username == rhs.username
    }

}
