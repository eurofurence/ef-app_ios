//
//  RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

protocol RandomValueProviding {
    
    static var random: Self { get }
    
}

extension RandomValueProviding {
    
    func randomized(ifFalse predicate: @autoclosure () -> Bool) -> Self {
        return predicate() ? self : Self.random
    }
    
}
