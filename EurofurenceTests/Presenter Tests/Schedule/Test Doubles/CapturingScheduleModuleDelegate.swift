//
//  CapturingScheduleModuleDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingScheduleModuleDelegate: ScheduleModuleDelegate {
    
    private(set) var capturedEventIdentifier: Event2.Identifier?
    func scheduleModuleDidSelectEvent(identifier: Event2.Identifier) {
        capturedEventIdentifier = identifier
    }
    
}
