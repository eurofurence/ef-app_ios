//
//  Room+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

extension Room: RandomValueProviding {
    
    static var random: Room {
        return Room(name: .random)
    }
    
}
