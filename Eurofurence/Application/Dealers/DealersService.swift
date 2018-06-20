//
//  DealersService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol DealersService {

    func makeDealersIndex() -> DealersIndex
    func fetchIconPNGData(for identifier: Dealer2.Identifier, completionHandler: @escaping (Data?) -> Void)

}

protocol DealersIndex {

    func setDelegate(_ delegate: DealersIndexDelegate)
    func performSearch(term: String)

}

protocol DealersIndexDelegate {

    func alphabetisedDealersDidChange(to alphabetisedGroups: [AlphabetisedDealersGroup])
    func indexDidProduceSearchResults(_ searchResults: [AlphabetisedDealersGroup])

}

struct AlphabetisedDealersGroup: Equatable {

    var indexingString: String
    var dealers: [Dealer2]

}
