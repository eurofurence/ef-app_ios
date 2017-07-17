//
//  LoginController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol LoginController {

    func add(_ observer: LoginStateObserver)

}

struct LoginCredential {

    var authenticationToken: String
    var tokenExpiryDate: Date

}

protocol LoginStateObserver {

    func userDidLogin(credential: LoginCredential)

}
