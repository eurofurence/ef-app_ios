//
//  Array+RandomConvenience.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension Array where Element: RandomValueProviding {
    
    static var random: [Element] {
        return random(minimum: 1)
    }
    
    static func random(minimum: Int) -> [Element] {
        let upperLimit = Int.random(upperLimit: 10) + minimum
        return (minimum...upperLimit).map { (_) in Element.random }
    }
    
}

extension Array {
    
    func randomElement() -> (index: Int, element: Element) {
        let randomIndex = Int.random(upperLimit: UInt32(count))
        return (index: randomIndex, element: self[randomIndex])
    }
    
}
