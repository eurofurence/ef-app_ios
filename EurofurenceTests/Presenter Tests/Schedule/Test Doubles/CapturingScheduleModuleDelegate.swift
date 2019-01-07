//
//  CapturingScheduleModuleDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class CapturingScheduleModuleDelegate: ScheduleModuleDelegate {

    private(set) var capturedEventIdentifier: EventIdentifier?
    func scheduleModuleDidSelectEvent(identifier: EventIdentifier) {
        capturedEventIdentifier = identifier
    }

}
