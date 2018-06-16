//
//  CapturingSignificantTimeChangeAdapterDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingSignificantTimeChangeAdapterDelegate: SignificantTimeChangeAdapterDelegate {
    
    private(set) var toldSignificantTimeChangeOccurred = false
    func significantTimeChangeDidOccur() {
        toldSignificantTimeChangeOccurred = true
    }
    
}
