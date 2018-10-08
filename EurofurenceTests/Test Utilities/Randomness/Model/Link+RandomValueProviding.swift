//
//  Link+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

extension Link: RandomValueProviding {
    
    static var random: Link {
        return Link(name: .random, type: .webExternal, contents: Int.random)
    }
    
}
