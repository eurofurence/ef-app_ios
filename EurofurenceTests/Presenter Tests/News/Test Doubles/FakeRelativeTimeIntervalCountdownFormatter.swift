//
//  FakeRelativeTimeIntervalCountdownFormatter.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class FakeRelativeTimeIntervalCountdownFormatter: RelativeTimeIntervalCountdownFormatter {
    
    private var strings = [TimeInterval : String]()
    
    func relativeString(from timeInterval: TimeInterval) -> String {
        var output = String.random
        if let previous = strings[timeInterval] {
            output = previous
        }
        else {
            strings[timeInterval] = output
        }
        
        return output
    }
    
}
