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
        let group = DealersGroupViewModel(dealers: [dealerViewModel])
        let viewModel = CapturingDealersViewModel(dealerGroups: [group])
        self.init(viewModel: viewModel)
    }
    
    init(viewModel: DealersViewModel) {
        self.viewModel = viewModel
    }
    
    func makeDealersViewModel(completionHandler: @escaping (DealersViewModel) -> Void) {
        completionHandler(viewModel)
    }
    
}
