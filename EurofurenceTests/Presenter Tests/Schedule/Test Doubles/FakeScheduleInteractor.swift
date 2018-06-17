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
    private let searchViewModel: ScheduleSearchViewModel
    
    init(viewModel: CapturingScheduleViewModel = .random,
         searchViewModel: CapturingScheduleSearchViewModel = CapturingScheduleSearchViewModel()) {
        self.viewModel = viewModel
        self.searchViewModel = searchViewModel
    }
    
    func makeViewModel(completionHandler: @escaping (ScheduleViewModel) -> Void) {
        completionHandler(viewModel)
    }
    
    func makeSearchViewModel(completionHandler: @escaping (ScheduleSearchViewModel) -> Void) {
        completionHandler(searchViewModel)
    }
    
}
