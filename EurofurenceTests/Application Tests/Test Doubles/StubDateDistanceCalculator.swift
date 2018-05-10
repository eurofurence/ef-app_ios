//
//  StubDateDistanceCalculator.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 10/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class StubDateDistanceCalculator: DateDistanceCalculator {
    
    func calculateDays(between first: Date, and second: Date) -> Int {
        if let value = stubbedValues.first(where: { $0.first == first && $0.second == second }) {
            return value.days
        }
        else {
            return .random
        }
    }
    
    private struct StubbedValue {
        var first: Date
        var second: Date
        var days: Int
    }
    
    private var stubbedValues = [StubbedValue]()
    func stubDistance(between first: Date, and second: Date, with days: Int) {
        stubbedValues.append(StubbedValue(first: first, second: second, days: days))
    }
    
}
