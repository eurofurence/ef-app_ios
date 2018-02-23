//
//  RandomRangedValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

protocol RandomRangedValueProviding {
    
    static func random(upperLimit: UInt32) -> Self
    
}
