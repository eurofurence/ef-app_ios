//
//  Map+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation
import RandomDataGeneration

extension Map: RandomValueProviding {
    
    public static var random: Map {
        return Map(identifier: .random, location: .random)
    }
    
}

extension Map.Identifier: RandomValueProviding {
    
    public static var random: Map.Identifier {
        return Map.Identifier(.random)
    }
    
}
