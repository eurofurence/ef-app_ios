//
//  User+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 07/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

extension User: RandomValueProviding {
    
    static var random: User {
        return User(registrationNumber: .random, username: .random)
    }
    
}
