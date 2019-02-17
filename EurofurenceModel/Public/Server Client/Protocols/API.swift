//
//  API.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 17/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

public protocol API: PrivateMessagesAPI, SyncAPI {

    func fetchImage(identifier: String, completionHandler: @escaping (Data?) -> Void)

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
