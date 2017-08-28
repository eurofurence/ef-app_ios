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
    func makeDescriptionForUnreadMessages(_ count: Int) -> String { return "" }
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
    
    private(set) var capturedUnreadMessageCount: Int?
    var stubbedUnreadMessageString = ""
    func makeDescriptionForUnreadMessages(_ count: Int) -> String {
        capturedUnreadMessageCount = count
        return stubbedUnreadMessageString
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
