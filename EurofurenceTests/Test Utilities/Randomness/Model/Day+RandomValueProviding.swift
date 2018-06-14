//
//  Day+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 14/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

extension Day: RandomValueProviding {
    
    static var random: Day {
        return Day(date: .random)
    }
    
}
