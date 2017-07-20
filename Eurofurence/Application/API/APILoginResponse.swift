//
//  APILoginResponse.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol APILoginResponse {

    var uid: Int { get }
    var username: String { get }
    var token: String { get }
    var tokenValidUntil: Date { get }

}
