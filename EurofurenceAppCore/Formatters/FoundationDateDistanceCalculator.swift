//
//  FoundationDateDistanceCalculator.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public struct FoundationDateDistanceCalculator: DateDistanceCalculator {
    
    public init() {
        
    }

    public func calculateDays(between first: Date, and second: Date) -> Int {
        let daysComponents = Set([Calendar.Component.day])
        let components = Calendar.current.dateComponents(daysComponents, from: first, to: second)

        return components.day!
    }

}
