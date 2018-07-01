//
//  CapturingDealersViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

final class CapturingDealersViewModel: DealersViewModel {
    
    var dealerGroups: [DealersGroupViewModel]
    var sectionIndexTitles: [String] = .random
    
    init(dealerGroups: [DealersGroupViewModel] = .random) {
        self.dealerGroups = dealerGroups
    }
    
    func setDelegate(_ delegate: DealersViewModelDelegate) {
        delegate.dealerGroupsDidChange(dealerGroups, indexTitles: sectionIndexTitles)
    }
    
    fileprivate var dealerIdentifiers = [IndexPath : Dealer2.Identifier]()
    func identifierForDealer(at indexPath: IndexPath) -> Dealer2.Identifier? {
        return dealerIdentifiers[indexPath]
    }
    
    private(set) var wasToldToRefresh = false
    func refresh() {
        wasToldToRefresh = true
    }
    
}

extension CapturingDealersViewModel {
    
    func stub(_ identifier: Dealer2.Identifier, forDealerAt indexPath: IndexPath) {
        dealerIdentifiers[indexPath] = identifier
    }
    
}
