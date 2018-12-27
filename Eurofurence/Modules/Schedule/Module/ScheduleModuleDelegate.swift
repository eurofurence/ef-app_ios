//
//  ScheduleModuleDelegate.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

protocol ScheduleModuleDelegate {

    func scheduleModuleDidSelectEvent(identifier: Event.Identifier)

}
