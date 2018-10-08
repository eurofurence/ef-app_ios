//
//  ScheduleModuleDelegate.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

protocol ScheduleModuleDelegate {

    func scheduleModuleDidSelectEvent(identifier: Event2.Identifier)

}
