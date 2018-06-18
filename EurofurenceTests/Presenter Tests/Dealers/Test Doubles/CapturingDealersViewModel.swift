//
//  CapturingDealersViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

struct CapturingDealersViewModel: DealersViewModel {
    
    var dealerGroups: [DealersGroupViewModel]
    var sectionIndexTitles: [String] = .random
    
    init(dealerGroups: [DealersGroupViewModel] = .random) {
        self.dealerGroups = dealerGroups
    }
    
    func setDelegate(_ delegate: DealersViewModelDelegate) {
        delegate.dealerGroupsDidChange(dealerGroups, indexTitles: sectionIndexTitles)
    }
    
}
