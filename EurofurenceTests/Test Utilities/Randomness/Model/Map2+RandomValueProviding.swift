//
//  Map2+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

extension Map2: RandomValueProviding {
    
    static var random: Map2 {
        return Map2()
    }
    
}
