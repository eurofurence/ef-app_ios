//
//  WelcomePromptStringFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol WelcomePromptStringFactory {

    func makeString(for user: User) -> String
    func makeDescriptionForUnreadMessages(_ count: Int)

    func makeStringForAnonymousUser() -> String
    func makeDescriptionForAnonymousUser() -> String

}

struct UnlocalizedWelcomePromptStringFactory: WelcomePromptStringFactory {

    func makeString(for user: User) -> String {
        return "Welcome, \(user.username) (\(user.registrationNumber))"
    }

    func makeDescriptionForUnreadMessages(_ count: Int) {

    }

    func makeStringForAnonymousUser() -> String {
        return "You are currently not logged in"
    }

    func makeDescriptionForAnonymousUser() -> String {
        return "Tap here to login using your registration details and receive personalized messages from Eurofurence!"
    }

}
