//
//  FakeScheduleInteractor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class FakeScheduleInteractor: ScheduleInteractor {
    
    private let viewModel: ScheduleViewModel
    
    init(viewModel: ScheduleViewModel = .random) {
        self.viewModel = viewModel
    }
    
    func setDelegate(_ delegate: ScheduleInteractorDelegate) {
        delegate.scheduleInteractorDidPrepareViewModel(viewModel)
    }
    
}
