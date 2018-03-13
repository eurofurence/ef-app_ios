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
        let upperLimit = Int.random(upperLimit: 10) + 1
        return (0..<upperLimit).map { (_) in Element.random }
    }
    
}

extension Array {
    
    func randomElement() -> (index: Int, element: Element) {
        let randomIndex = Int.random(upperLimit: UInt32(count))
        return (index: randomIndex, element: self[randomIndex])
    }
    
}
