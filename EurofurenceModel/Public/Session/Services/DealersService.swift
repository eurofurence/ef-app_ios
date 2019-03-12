//
//  DealersService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public protocol DealersService {
    
    func fetchDealer(for identifier: DealerIdentifier) -> Dealer?

    func makeDealersIndex() -> DealersIndex
    func openTelegram(for identifier: DealerIdentifier)

}

public protocol DealersIndex {

    func setDelegate(_ delegate: DealersIndexDelegate)
    func performSearch(term: String)

}

public protocol DealersIndexDelegate {

    func alphabetisedDealersDidChange(to alphabetisedGroups: [AlphabetisedDealersGroup])
    func indexDidProduceSearchResults(_ searchResults: [AlphabetisedDealersGroup])

}

public struct AlphabetisedDealersGroup {

    public var indexingString: String
    public var dealers: [Dealer]

    public init(indexingString: String, dealers: [Dealer]) {
        self.indexingString = indexingString
        self.dealers = dealers
    }

}
