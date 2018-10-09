//
//  FakeShortFormDateFormatter.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import Foundation

class FakeShortFormDateFormatter: ShortFormDateFormatter {
    
    func dateString(from date: Date) -> String {
        return "Short Form | \(date.description)"
    }
    
}
