//
//  LoginResponse.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

public struct LoginResponse {

    public var userIdentifier: String
    public var username: String
    public var token: String
    public var tokenValidUntil: Date

    public init(userIdentifier: String, username: String, token: String, tokenValidUntil: Date) {
        self.userIdentifier = userIdentifier
        self.username = username
        self.token = token
        self.tokenValidUntil = tokenValidUntil
    }

}
