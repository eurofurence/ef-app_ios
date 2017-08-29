//
//  RandomGenerator.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Darwin

struct Random {
    
    static func makeRandomNumber() -> Int {
        return Int(arc4random())
    }
    
    static func makeRandomNumber(upperLimit: Int) -> Int {
        return Int(arc4random_uniform(UInt32(upperLimit)))
    }
    
}
