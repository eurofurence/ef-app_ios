//
//  DealersService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public protocol DealersService {

    func makeDealersIndex() -> DealersIndex
    func fetchIconPNGData(for identifier: Dealer2.Identifier, completionHandler: @escaping (Data?) -> Void)
    func fetchExtendedDealerData(for dealer: Dealer2.Identifier, completionHandler: @escaping (ExtendedDealerData) -> Void)
    func openWebsite(for identifier: Dealer2.Identifier)
    func openTwitter(for identifier: Dealer2.Identifier)
    func openTelegram(for identifier: Dealer2.Identifier)

}

public protocol DealersIndex {

    func setDelegate(_ delegate: DealersIndexDelegate)
    func performSearch(term: String)

}

public protocol DealersIndexDelegate {

    func alphabetisedDealersDidChange(to alphabetisedGroups: [AlphabetisedDealersGroup])
    func indexDidProduceSearchResults(_ searchResults: [AlphabetisedDealersGroup])

}

public struct AlphabetisedDealersGroup: Equatable {

    public var indexingString: String
    public var dealers: [Dealer2]

    public init(indexingString: String, dealers: [Dealer2]) {
        self.indexingString = indexingString
        self.dealers = dealers
    }

}
