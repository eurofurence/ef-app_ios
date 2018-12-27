//
//  CapturingDealersViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

final class CapturingDealersViewModel: DealersViewModel {

    var dealerGroups: [DealersGroupViewModel]
    var sectionIndexTitles: [String] = .random

    init(dealerGroups: [DealersGroupViewModel] = .random) {
        self.dealerGroups = dealerGroups
    }

    private(set) var delegate: DealersViewModelDelegate?
    func setDelegate(_ delegate: DealersViewModelDelegate) {
        self.delegate = delegate
        delegate.dealerGroupsDidChange(dealerGroups, indexTitles: sectionIndexTitles)
    }

    fileprivate var dealerIdentifiers = [IndexPath: Dealer.Identifier]()
    func identifierForDealer(at indexPath: IndexPath) -> Dealer.Identifier? {
        return dealerIdentifiers[indexPath]
    }

    private(set) var wasToldToRefresh = false
    func refresh() {
        wasToldToRefresh = true
    }

}

extension CapturingDealersViewModel {

    func stub(_ identifier: Dealer.Identifier, forDealerAt indexPath: IndexPath) {
        dealerIdentifiers[indexPath] = identifier
    }

}
