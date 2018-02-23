//
//  RandomGenerator.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Darwin

struct Random {
    
    static func makeRandomBool() -> Bool {
        return Int.random(upperLimit: 100) > 50
    }
    
}
