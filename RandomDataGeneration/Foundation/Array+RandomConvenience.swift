//
//  Array+RandomConvenience.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public extension Array where Element: RandomValueProviding {
    
    public static var random: [Element] {
        return random(minimum: 1)
    }
    
    public static func random(minimum: Int) -> [Element] {
        let upperLimit = Int.random(upperLimit: 10) + minimum
        return random(upperLimit: upperLimit)
    }
    
    public static func random(upperLimit: Int) -> [Element] {
        return (0...upperLimit).map { (_) in Element.random }
    }
    
    public static func randomWithMutations(_ block: (inout Element) -> Void) -> [Element] {
        let elements = self.random
        var copy = elements
        for (idx, element) in elements.enumerated() {
            var elementCopy = element
            block(&elementCopy)
            copy[idx] = elementCopy
        }
        
        return copy
    }
    
    public func take(upTo count: Int) -> [Element] {
        var output = [Element]()
        var i = 0
        repeat {
            guard i < count else { break }
            
            output.append(self[i])
            i += 1
        } while i < count
        
        return output
    }
    
}

public extension Array {
    
    public func randomElement() -> (index: Int, element: Element) {
        let randomIndex = Int.random(upperLimit: UInt32(count))
        return (index: randomIndex, element: self[randomIndex])
    }
    
}
