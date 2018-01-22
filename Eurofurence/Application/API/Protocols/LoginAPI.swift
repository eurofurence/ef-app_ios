//
//  LoginAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

protocol LoginAPI {

    func performLogin(request: LoginRequest)

}

struct LoginRequest {

    var regNo: Int
    var username: String
    var password: String
    var completionHandler: (LoginResponse?) -> Void

}
