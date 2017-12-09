//
//  LoginServiceRequest.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct LoginServiceRequest: Equatable {

    var registrationNumber: Int
    var username: String
    var password: String

    static func ==(lhs: LoginServiceRequest, rhs: LoginServiceRequest) -> Bool {
        return lhs.registrationNumber == rhs.registrationNumber &&
            lhs.username == rhs.username &&
            lhs.password == rhs.password
    }

}

enum LoginServiceResult {
    case success
    case failure
}
