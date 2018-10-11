//
//  CapturingScheduleModuleDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import Foundation

class CapturingScheduleModuleDelegate: ScheduleModuleDelegate {
    
    private(set) var capturedEventIdentifier: Event.Identifier?
    func scheduleModuleDidSelectEvent(identifier: Event.Identifier) {
        capturedEventIdentifier = identifier
    }
    
}
