//
//  CapturingHapticEngine.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingHapticEngine: HapticEngine {
    
    private(set) var didPlaySelectionHaptic = false
    func playSelectionHaptic() {
        didPlaySelectionHaptic = true
    }
    
}
