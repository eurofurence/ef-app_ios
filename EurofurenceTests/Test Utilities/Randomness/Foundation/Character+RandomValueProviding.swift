//
//  Character+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 31/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension Character: RandomValueProviding {
    
    static var random: Character {
        return String.random.first!
    }
    
}
