//
//  FakeDateRangeFormatter.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 21/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class FakeDateRangeFormatter: DateRangeFormatter {
    
    private var strings = [DateInterval : String]()
    func string(from startDate: Date, to endDate: Date) -> String {
        let interval = DateInterval(start: startDate, end: endDate)
        var string: String
        if let str = strings[interval] {
            string = str
        }
        else {
            string = .random
        }
        
        strings[interval] = string
        
        return string
    }
    
}
