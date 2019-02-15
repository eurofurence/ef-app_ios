//
//  Credential.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

public struct Credential {

    public var username: String
    public var registrationNumber: Int
    public var authenticationToken: String
    public var tokenExpiryDate: Date

    public init(username: String, registrationNumber: Int, authenticationToken: String, tokenExpiryDate: Date) {
        self.username = username
        self.registrationNumber = registrationNumber
        self.authenticationToken = authenticationToken
        self.tokenExpiryDate = tokenExpiryDate
    }

    public func isValid(currentDate: Date) -> Bool {
        return currentDate < tokenExpiryDate
    }

}
