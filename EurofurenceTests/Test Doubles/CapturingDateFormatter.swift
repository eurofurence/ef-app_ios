//
//  CapturingDateFormatter.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingDateFormatter: DateFormatterProtocol {
    
    var stubString = "Stub"
    private(set) var capturedDate: Date?
    func string(from date: Date) -> String {
        capturedDate = date
        return stubString
    }
    
}
