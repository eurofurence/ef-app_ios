//
//  CapturingScheduleInteractorDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingScheduleInteractorDelegate: ScheduleInteractorDelegate {
    
    private(set) var viewModel: ScheduleViewModel?
    func scheduleInteractorDidPrepareViewModel(_ viewModel: ScheduleViewModel) {
        self.viewModel = viewModel
    }
    
}
