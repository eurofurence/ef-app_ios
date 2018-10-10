//
//  Link+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation
import RandomDataGeneration

extension Link: RandomValueProviding {
    
    public static var random: Link {
        return Link(name: .random, type: .webExternal, contents: Int.random)
    }
    
}
