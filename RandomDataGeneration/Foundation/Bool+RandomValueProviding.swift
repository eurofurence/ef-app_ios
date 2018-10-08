//
//  Bool+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension Bool: RandomValueProviding {
    
    public static var random: Bool {
        return Int.random(upperLimit: 100) % 2 == 0
    }
    
}
