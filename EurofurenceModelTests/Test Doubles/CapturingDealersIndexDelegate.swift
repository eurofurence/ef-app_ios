//
//  CapturingDealersIndexDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class CapturingDealersIndexDelegate: DealersIndexDelegate {

    private(set) var capturedAlphabetisedDealerSearchResults = [AlphabetisedDealersGroup]()
    func indexDidProduceSearchResults(_ searchResults: [AlphabetisedDealersGroup]) {
        capturedAlphabetisedDealerSearchResults = searchResults
    }

    private(set) var toldAlphabetisedDealersDidChangeToEmptyValue = false
    private(set) var capturedAlphabetisedDealerGroups = [AlphabetisedDealersGroup]()
    func alphabetisedDealersDidChange(to alphabetisedGroups: [AlphabetisedDealersGroup]) {
        toldAlphabetisedDealersDidChangeToEmptyValue = alphabetisedGroups.isEmpty
        capturedAlphabetisedDealerGroups = alphabetisedGroups
    }

}

extension CapturingDealersIndexDelegate {

    func capturedDealer(for identifier: DealerIdentifier) -> Dealer? {
        return capturedAlphabetisedDealerGroups.map({ $0.dealers }).joined().first(where: { $0.identifier == identifier })
    }

}
