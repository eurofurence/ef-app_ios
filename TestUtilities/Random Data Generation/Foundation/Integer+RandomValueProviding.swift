//
//  Integer+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public extension BinaryInteger {

    static var random: Self {
        return Self(arc4random())
    }

    static func random(upperLimit: UInt32) -> Self {
        return Self(arc4random_uniform(upperLimit))
    }

}

extension Int: RandomValueProviding, RandomRangedValueProviding { }
