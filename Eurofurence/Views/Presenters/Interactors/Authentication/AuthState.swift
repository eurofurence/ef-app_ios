//
//  AuthState.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

enum AuthState: CustomStringConvertible, Equatable {
    case loggedIn(User)
    case loggedOut

    var description: String {
        switch self {
        case .loggedIn(let user):
            return "\(user.username) (\(user.registrationNumber))"
        default:
            return "Logged Out"
        }
    }

    static func ==(lhs: AuthState, rhs: AuthState) -> Bool {
        switch (lhs, rhs) {
        case (.loggedIn(let lhsUser), .loggedIn(let rhsUser)):
            return lhsUser == rhsUser

        case (.loggedOut, .loggedOut):
            return true

        default:
            return false
        }
    }
}
