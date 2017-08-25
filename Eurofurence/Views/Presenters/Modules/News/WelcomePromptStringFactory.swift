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
    func makeStringForAnonymousUser() -> String

}
