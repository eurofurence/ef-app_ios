//
//  Announcement2+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore

extension Announcement2: RandomValueProviding {
    
    static var random: Announcement2 {
        return Announcement2(identifier: .random,
                             title: .random,
                             content: .random,
                             date: .random)
    }
    
}

extension Announcement2.Identifier: RandomValueProviding {
    
    static var random: Announcement2.Identifier {
        return Announcement2.Identifier(.random)
    }
    
}
