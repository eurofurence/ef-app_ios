//
//  FakeDealersInteractor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

struct FakeDealersInteractor: DealersInteractor {
    
    var viewModel: DealersViewModel
    
    init(dealerViewModel: DealerViewModel) {
        let group = DealersGroupViewModel(title: .random, dealers: [dealerViewModel])
        self.init(dealerGroupViewModels: [group])
    }
    
    init(dealerGroupViewModels: [DealersGroupViewModel]) {
        let viewModel = CapturingDealersViewModel(dealerGroups: dealerGroupViewModels)
        self.init(viewModel: viewModel)
    }
    
    init(viewModel: DealersViewModel) {
        self.viewModel = viewModel
    }
    
    func makeDealersViewModel(completionHandler: @escaping (DealersViewModel) -> Void) {
        completionHandler(viewModel)
    }
    
}
