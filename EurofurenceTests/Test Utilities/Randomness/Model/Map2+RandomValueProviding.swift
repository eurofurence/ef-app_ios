//
//  Map2+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation
import RandomDataGeneration

extension Map2: RandomValueProviding {
    
    public static var random: Map2 {
        return Map2(identifier: .random, location: .random)
    }
    
}

extension Map2.Identifier: RandomValueProviding {
    
    public static var random: Map2.Identifier {
        return Map2.Identifier(.random)
    }
    
}
