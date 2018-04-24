//
//  Announcement2+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

extension Announcement2: RandomValueProviding {
    
    static var random: Announcement2 {
        return Announcement2(title: .random, content: .random)
    }
    
}
