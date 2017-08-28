//
//  WelcomePromptStringFactoryTestDoubles.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

struct DummyWelcomePromptStringFactory: WelcomePromptStringFactory {
    
    func makeString(for user: User) -> String { return "" }
    func makeStringForAnonymousUser() -> String { return "" }
    func makeDescriptionForAnonymousUser() -> String { return "" }
    
}

class CapturingWelcomePromptStringFactory: WelcomePromptStringFactory {
    
    private(set) var capturedWelcomePromptUser: User?
    var stubbedUserString = ""
    func makeString(for user: User) -> String {
        capturedWelcomePromptUser = user
        return stubbedUserString
    }
    
    var stubbedLoginString = ""
    func makeStringForAnonymousUser() -> String {
        return stubbedLoginString
    }
    
    var stubbedLoginDescriptionString = ""
    func makeDescriptionForAnonymousUser() -> String {
        return stubbedLoginDescriptionString
    }
    
}
