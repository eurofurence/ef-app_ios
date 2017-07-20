//
//  StubLoginResponse.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

struct StubLoginResponse: APILoginResponse {
    var uid: Int
    var username: String
    var token: String
    var tokenValidUntil: Date
}
