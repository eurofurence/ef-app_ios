//
//  LoginAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

public protocol LoginAPI {

    func performLogin(request: LoginRequest, completionHandler: @escaping (LoginResponse?) -> Void)

}

public struct LoginRequest {

    public var regNo: Int
    public var username: String
    public var password: String

    public init(regNo: Int, username: String, password: String) {
        self.regNo = regNo
        self.username = username
        self.password = password
    }

}
