//
//  LoginService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/11/2017.
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

protocol LoginService {

    func perform(_ request: LoginServiceRequest, completionHandler: @escaping (LoginServiceResult) -> Void)

}

enum LoginServiceResult {
    case success
}
