//
//  Int+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension BinaryInteger {
    
    static var random: Self {
        return Self(arc4random())
    }
    
}

extension Int: RandomValueProviding { }
