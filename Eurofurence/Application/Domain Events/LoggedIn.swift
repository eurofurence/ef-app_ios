//
//  LoggedIn.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

extension DomainEvent {

    struct LoggedIn {
        var user: User
        var authenticationToken: String
    }

}
